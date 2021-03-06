require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Candygram
  describe Candygram::Wrapper do
    describe "wrapping" do
  
      it "can wrap an array of simple arguments" do
        a = ["Hi", 1, nil, 17.536]
        Wrapper.wrap_array(a).should == a
      end
    
      it "can wrap a string" do
        Wrapper.wrap("Hi").should == "Hi"
      end

      it "can wrap nil" do
        Wrapper.wrap(nil).should == nil
      end
    
      it "can wrap true" do
        Wrapper.wrap(true).should be_true
      end
    
      it "can wrap false" do
        Wrapper.wrap(false).should be_false
      end
    
      it "can wrap an integer" do
        Wrapper.wrap(5).should == 5
      end
    
      it "can wrap a float" do
        Wrapper.wrap(17.950).should == 17.950
      end
    
      it "can wrap an already serialized bytestream" do
        b = BSON.serialize(:foo => 'bar')
        Wrapper.wrap(b).should == b
      end
    
      it "can wrap an ObjectID" do
        i = Mongo::ObjectID.new
        Wrapper.wrap(i).should == i
      end
  
      it "can wrap the time" do
        t = Time.now
        Wrapper.wrap(t).should == t
      end
    
      it "can wrap a regular expression" do
        r = /ha(l+)eluja(h?)/i
        Wrapper.wrap(r).should == r
      end
    
      it "can wrap a Mongo code object (if we ever need to)" do
        c = Mongo::Code.new('5')
        Wrapper.wrap(c).should == c
      end
    
      it "can wrap a Mongo DBRef (if we ever need to)" do
        d = Mongo::DBRef.new('foo', Mongo::ObjectID.new)
        Wrapper.wrap(d).should == d
      end
    
      it "can wrap a date as a time" do
        d = Date.today
        Wrapper.wrap(d).should == Date.today.to_time
      end
    
      it "can wrap other numeric types (which might throw exceptions later but oh well)" do
        c = Complex(2, 5)
        Wrapper.wrap(c).should == c
      end
    
      it "can wrap a symbol in a way that preserves its symbolic nature" do
        Wrapper.wrap(:oldglory).should == "__sym_oldglory"
      end
    
      it "wraps an array recursively" do
        a = [5, 'hi', [':symbol', 0], nil]
        Wrapper.wrap(a).should == a
      end
      
      it "wraps a hash's keys" do
        h = {"foo" => "bar", :yoo => "yar"}
        Wrapper.wrap(h).keys.should == ["foo", "__sym_yoo"]
      end
    
      it "wraps a hash's values" do
        h = {:foo => :bar, :yoo => [:yar, 5]}
        Wrapper.wrap(h).values.should == ["__sym_bar", ["__sym_yar", 5]]
      end
      
      it "rejects procs"
      
      describe "objects" do
        before(:each) do
          @missile = Missile.new
          @missile.payload = "15 megatons"
          @missile.rocket = [2, Object.new]
          @this = Wrapper.wrap(@missile)
        end
        
        it "returns a hash" do
          @this.should be_a(Hash)
        end
        
        it "keys the hash to be an object" do
          @this.keys.should == ["__object_"]
        end
        
        it "knows the object's class" do
          @this["__object_"]["class"].should == "Missile"
        end
        
        it "captures all the instance variables" do
          ivars = @this["__object_"]["ivars"]
          ivars.should have(2).elements
          ivars["@payload"].should == "15 megatons"
          ivars["@rocket"][1]["__object_"]["class"].should == "Object"
        end
        
        it "avoids circular dependencies"
        
      end
    end
    
    describe "unwrapping" do
      before(:each) do
        @wrapped = {"__object_" => {
          "class" => "Missile",
          "ivars" => {
            "@payload" => "6 kilotons",
            "@rocket" => [1, {"__object_" => {
              "class" => "Object"
            }}]
          }
        }}
      end
      it "passes most things through untouched" do
        Wrapper.unwrap(5).should == 5
      end
      
      it "turns symbolized strings back into symbols" do
        Wrapper.unwrap("__sym_blah").should == :blah
      end
      
      it "turns hashed objects back into objects" do
        obj = Wrapper.unwrap(@wrapped)
        obj.should be_a(Missile)
        obj.payload.should == "6 kilotons"
        obj.rocket[0].should == 1
        obj.rocket[1].should be_an(Object)
      end
        
      it "traverses a hash and unwraps whatever it needs to" do
        hash = {"__sym_foo" => "__sym_bar", "missile" => @wrapped}
        unwrapped = Wrapper.unwrap(hash)
        unwrapped[:foo].should == :bar
        unwrapped["missile"].should be_a(Missile)
      end
      
      it "traverses an array and unwraps whatever it needs to" do
        array = ["__sym_foo", 5, @wrapped, nil, "hi"]
        unwrapped = Wrapper.unwrap(array)
        unwrapped[0].should == :foo
        unwrapped[1].should == 5
        unwrapped[2].should be_a(Missile)
        unwrapped[3].should be_nil
        unwrapped[4].should == "hi"
      end
    
    end
      
  
  end
end
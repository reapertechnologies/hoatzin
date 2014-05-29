require 'helper'

class TestHoatzin < MiniTest::Unit::TestCase

  context "An untrained Hoatzin classifier" do

    setup do
      @c = Hoatzin::Classifier.new()
    end

    should "support training and classification" do
      assert_equal @c.train(:positive, "Thats nice"), [0] #[[1, 1]]
      assert_equal @c.classify("Thats nice"), :positive
    end

    context "that has been trained" do

      setup do
        TRAINING_LABELS.each_with_index do |label, index|
          @c.train(label, TRAINING_DOCS[index])
        end
      end

      should "classify the test set correctly" do
        TESTING_LABELS.each_with_index do |label, index|
          assert_equal @c.classify(TESTING_DOCS[index]), label
        end
        #@c.save(:metadata => READONLY_METADATA_FILE, :model => READONLY_MODEL_FILE, :update => false)
      end

      should "return the classifications" do
        assert_equal @c.classifications, [1,0]
      end
    end

  end

  context "An untrained Hoatzin classifier with an un-updatable model" do

    setup do
      @c = Hoatzin::Classifier.new(:metadata => READONLY_METADATA_FILE, :model => READONLY_MODEL_FILE )
    end

    should "classify the test set correctly" do
      TESTING_LABELS.each_with_index do |label, index|
        assert_equal @c.classify(TESTING_DOCS[index]), label
      end
    end

    should "not allow further training" do
      #@c.train(:positive, "Thats nice")
      assert_raises(Hoatzin::Classifier::ReadOnly) { @c.train(:positive, "Thats nice") }
    end

  end

  context "An untrained Hoatzin classifier with an updatable model" do

    setup do
      @c = Hoatzin::Classifier.new(:metadata => METADATA_FILE, :model => MODEL_FILE )
    end

    should "classify the test set correctly" do
      TESTING_LABELS.each_with_index do |label, index|
        assert_equal @c.classify(TESTING_DOCS[index]), label
      end
    end

    should "allow further training" do
      begin
        @c.train :positive, "Thats nice"
      rescue
        fail "Exception raised in 'train' method"
      end
    end

  end

end

require 'spec_helper'

describe Answer do
  let(:user1) { create :user }
  let(:user2) { create :user }
  before { answer.hit input: "hello", user: user1 }

  describe "#spelling_hot?" do
    context "when not reusable" do
      subject { answer.spelling_hot? input: "Hellllo", user: user2 }
      context "when spelling not matters" do # произношение не влияет, т.е. ИВЕНТ МОЖЕТ ВОЗНИКНУТЬ ТОЛЬКО 1 РАЗ
        let(:answer) { create :answer, body: "he(l)*o", spelling_matters: false }
        it { should be_false }
      end
      context "when spelling matters" do # произношение влияет, т.е. ивент может возникнуть если использовано другое произношение
        let(:answer) { create :answer, body: "he(l)*o", spelling_matters: true }
        it { should be_true }
      end
    end
  end

  describe "#reusable_hot?" do
    context "when reusable by other" do
      let(:answer) { create :answer, body: "he(l)*o", reusable: :for_other}
      context "when other user" do
        subject { answer.reusable_hot? input: "hello", user: user2 }
        it { should be_true }
      end
      context "when this user" do
        subject { answer.reusable_hot? input: "hellllo", user: user1 }
        it { should be_false }
      end
    end
    context "when reusable by all" do
      let(:answer) { create :answer, body: "he(l)*o", reusable: :for_all }
      subject { answer.reusable_hot? input: "hello", user: user1 }
      it { should be_true }
    end
  end

  describe "#body_hot?" do
    let(:answer) { create :answer, body: "he(l)*o" }
    subject { answer.body_hot? input: "Hellllo, world!" }
    it { should be_true }
  end

end
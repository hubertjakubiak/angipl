require "rails_helper" 

describe GamesController do
  let!(:word) { create(:word, en: "cat", pl: "kot") }
  let!(:word_2) { create(:word, en: "dog", pl: "pies") }

  describe "#check" do
    context "when user types asnwer" do
      context "when answer is correct" do
        let(:time_now) { Time.now.to_i.to_s}
        let(:params) { { word: { en: "cat", pl: "kot" } , time: time_now } }

        before do
          post :check, params
        end

        it "assings @en to word.en" do
          expect(assigns(:en)).to eq word.en
        end

        it "assings @pl to word.pl" do
          expect(assigns(:pl)).to eq word.pl
        end

        it "assings @time to time_now" do
          expect(assigns(:time)).to eq time_now
        end

        it "returns count of matched translations" do
          expect(assigns(:result)).to eq "1"
        end

        it "returns status" do
          expect(response.status).to eq 200
        end
      end

      context "when answer is not correct" do
        let(:params) { { en: "cat", pl: "pies" } }

        it "returns count of matched translations" do
          post :check, params
          expect(assigns(:result)).to eq "0"
        end

        it "returns status" do
          post :check, params
          expect(response.status).to eq 200
        end
      end
    end
    context "when user selects answer" do
      context "when answer is correct" do
        let(:time_now) { Time.now.to_i.to_s}
        let(:params) { { en: "cat", pl: "kot" , time: time_now} }

        before do
          post :check, params
        end

        it "assings @en to word.en" do
          expect(assigns(:en)).to eq word.en
        end

        it "assings @pl to word.pl" do
          expect(assigns(:pl)).to eq word.pl
        end

        it "assings @time to time_now" do
          expect(assigns(:time)).to eq time_now
        end

        it "returns count of matched translations" do
          expect(assigns(:result)).to eq "1"
        end

        it "returns status" do
          expect(response.status).to eq 200
        end
      end

      context "when answer is not correct" do
        let(:params) { { en: "cat", pl: "pies" } }

        it "returns count of matched translations" do
          post :check, params
          expect(assigns(:result)).to eq "0"
        end

        it "returns status" do
          post :check, params
          expect(response.status).to eq 200
        end
      end
    end
  end
end

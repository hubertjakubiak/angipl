require "rails_helper"

describe GamesController do
  describe "#index" do
    context "when there are any words" do
      let(:call) { get :index }

      before { call }

      it "redirects to words_path" do
        expect(response).to redirect_to(words_path)
      end

      it "has status 302" do
        expect(response.status).to eq 302
      end

      it "sets flash message" do
        expect(flash[:notice]).to eq I18n.t("messages.not_enough_words")
      end
    end

    context "where there are some words" do
      let!(:words) do
        create_list(:word, 10, categories: [create(:category, name: "Biznes")])
      end

      context "when user selects my words" do
        context "when user has enough my words" do
          let(:user) { create(:user) }
          let!(:user_words) do
            create_list(:word, 7, user: user, categories: [create(:category, name: "Biznes")])
          end
          let(:params) { { category: "Moje słówka" } }
          let(:call) { get :index, params }

          before do
            controller.stub(:current_user) { user }
            call
          end

          it "renders index template" do
            expect(response).to render_template(:index)
          end

          it "has status 200" do
            expect(response.status).to eq 200
          end
        end

        context "when user does not have enough words" do
          let(:user) { create(:user) }
          let!(:user_words) do
            create_list(:word, 3, user: user, categories: [create(:category, name: "Biznes")])
          end
          let(:params) { { category: "Moje słówka" } }
          let(:call) { get :index, params }

          before do
            controller.stub(:current_user) { user }
            call
          end

          it "redirects to root_path" do
            expect(response).to redirect_to(root_path)
          end

          it "has status 302" do
            expect(response.status).to eq 302
          end

          it "sets flash message" do
            expect(flash[:notice]).to eq I18n.t("messages.my_words_not_enough")
          end
        end
      end

      context "when category is defined and exists" do
        context "when category has enough words" do
          let!(:category_words) do
            create_list(:word, 7, categories: [create(:category, name: "Nauka")])
          end
          let(:params) { { category: "Nauka" } }
          let(:call) { get :index, params }

          before { call }

          it "renders index template" do
            expect(response).to render_template(:index)
          end

          it "has status 200" do
            expect(response.status).to eq 200
          end
        end

        context "when category does not have enough words" do
          let!(:category_words) do
            create_list(:word, 3, categories: [create(:category, name: "Nauka")])
          end
          let(:params) { { category: "Nauka" } }
          let(:call) { get :index, params }

          before { call }

          it "redirects to root_path" do
            expect(response).to redirect_to(root_path)
          end

          it "has status 302" do
            expect(response.status).to eq 302
          end

          it "sets flash message" do
            expect(flash[:notice]).to eq I18n.t("messages.category_needs_more_words")
          end
        end
      end

      context "when category is defined but not exists" do
        let(:params) { { category: "CategoryName" } }
        let(:call) { get :index, params }

        before { call }

        it "redirects to root path" do
          expect(response).to redirect_to(root_path)
        end

        it "has status 302" do
          expect(response.status).to eq 302
        end

        it "sets flash message" do
          expect(flash[:notice]).to eq I18n.t("messages.category_does_not_exist")
        end
      end
    end
  end

  describe "#check" do
    let!(:word) { create(:word, en: "cat", pl: "kot") }
    let!(:another_word) { create(:word, en: "dog", pl: "pies") }

    context "when user types asnwer" do
      context "when answer is correct" do
        let(:time_now) { Time.now.to_i.to_s }
        let(:params) { { word: { en: "cat", pl: "kot" } , time: time_now } }
        let(:call) { post :check, params }

        before { call }

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
        let(:call) { post :check, params }

        before { call }

        it "returns count of matched translations" do
          expect(assigns(:result)).to eq "0"
        end

        it "returns status" do
          expect(response.status).to eq 200
        end
      end
    end
    context "when user selects answer" do
      context "when answer is correct" do
        let(:time_now) { Time.now.to_i.to_s }
        let(:params) { { en: "cat", pl: "kot" , time: time_now } }
        let(:call) { post :check, params }

        before { call }

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

        it "has status 200" do
          expect(response.status).to eq 200
        end
      end

      context "when answer is not correct" do
        let(:params) { { en: "cat", pl: "pies" } }
        let(:call) { post :check, params }

        before { call }

        it "returns count of matched translations" do
          expect(assigns(:result)).to eq "0"
        end

        it "has status 200" do
          expect(response.status).to eq 200
        end
      end
    end
  end
end

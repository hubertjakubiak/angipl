require "rails_helper"

describe WordsController do
  describe "#index" do
    let(:call) { get :index }

    before { call }

    it "renders the index template" do     
      expect(response).to render_template("index")
    end

    it "has status 200" do
      expect(response.status).to eq 200
    end
  end

  describe "#my" do
    context "when user is not signed in" do
      let(:call) { get :my }

      before { call }
      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end

      it "has status 302" do
        expect(response.status).to eq 302
      end

      it "raises error" do
        expect { controller.my }.to raise_error(I18n.t("messages.login_to_add_new_word"))
      end
    end

    context "when user is signed in" do
      let!(:user) { create(:user) }
      let(:call) { get :my }
    
      before do
        controller.stub(:current_user) { user }
        call
      end

      it "renders my template" do
        expect(response).to render_template(:my)
      end

      it "has status 200" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "#new" do
    context "when user is not signed in" do
      let(:call) { get :new }

      before { call }
      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end

      it "has status 302" do
        expect(response.status).to eq 302
      end

      it "raises error" do
        expect { controller.my }.to raise_error(I18n.t("messages.login_to_add_new_word"))
      end
    end

    context "when user is signed in" do
      let!(:user) { create(:user) }
      let(:call) { get :new }
    
      before do
        controller.stub(:current_user) { user }
        call
      end

      it "renders my template" do
        expect(response).to render_template(:new)
      end

      it "has status 200" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "#edit" do
    let!(:word) { create(:word) }

    context "when user is not signed in" do
      let(:call) { get :edit, { id: word.id } }

      before { call }

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end

      it "has status 302" do
        expect(response.status).to eq 302
      end

      it "raises error" do
        expect { controller.edit }.to raise_error(I18n.t("messages.you_cant_edit_this_word"))
      end
    end

    context "when user is signed in" do
      let!(:user) { create(:user) }
      let(:call) { get :edit, { id: word.id } }
    
      before do
        controller.stub(:current_user) { user }
        call
      end

      context "when user edits his word" do
        let!(:word) { create(:word, user: user) }

        it "renders edit template" do
          expect(response).to render_template(:edit)
        end

        it "has status 200" do
          expect(response.status).to eq 200
        end
      end

      context "when user edits not his word" do
        let!(:word) { create(:word) }

        it "redirects to root_path" do
          expect(response).to redirect_to(root_path)
        end

        it "has status 302" do
          expect(response.status).to eq 302
        end

        it "raises error" do
          expect { controller.edit }.to raise_error(I18n.t("messages.you_cant_edit_this_word"))
        end
      end
    end
  end

  describe "#create" do
    context "when user is signed in" do
      let!(:user) { create(:user) }
      let!(:category) { create(:category) }
      let(:call) { post :create, params }

      before do |example|
        unless example.metadata[:skip_before]
          controller.stub(:current_user) { user }
          call
        end
      end

      context "valid params" do
        let(:params) { { word: { en: "dog", pl: "pies", user_id: user.id, category_ids: [category.id] } } }

        it "redirects to new_word_path" do
          expect(response).to redirect_to(new_word_path)
        end

        it "has status 302" do
          expect(response.status).to eq 302
        end

        it "sets flash message" do
          expect(flash[:notice]).to eq(I18n.t("messages.word_was_saved"))
        end

        it "persists new word", :skip_before do
          controller.stub(:current_user) { user }
          expect { call }.to change { Word.count }.from(0).to(1)
        end
      end

      context "not valid params" do
        let(:params) { { word: { en: "", pl: "", user_id: user.id, category_ids: [category.id] } } }

        it "renders new template" do
          expect(response).to render_template(:new)
        end

        it "has status 200" do
          expect(response.status).to eq 200
        end

        it "does not persist new word", :skip_before do
          controller.stub(:current_user) { user }
          expect { call }.not_to change { Word.count }
        end
      end
    end

    context "when user is not signed in" do
      let!(:category) { create(:category) }
      let(:params) { { word: { en: "dog", pl: "pies", user_id: "5", category_ids: [category.id] } } }
      let(:call) { post :create, params }

      before { call }

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end

      it "has status 302" do
        expect(response.status).to eq 302
      end

      it "sets flash message" do
        expect { controller.create }.to raise_error(I18n.t("messages.login_to_add_new_word"))
      end
    end
  end

  describe "#update" do
    context "when user is signed in" do
      let!(:user) { create(:user) }
      let!(:word) { create(:word) }
      let(:call) { put :update, params }

      before do
        controller.stub(:current_user) { user }
        call
      end

      context "valid params" do
        let(:params) { { id: word.id, word: { en: "dog", pl: "pies" } } }

        it "redirects to word_path" do
          expect(response).to redirect_to(word_path(word))
        end

        it "has status 302" do
          expect(response.status).to eq 302
        end

        it "sets flash message" do
          expect(flash[:notice]).to eq I18n.t("messages.word_was_edited")
        end

        it "changes en value" do
          expect(word.reload.en).to eq params[:word][:en]
        end

        it "changes pl value" do
          expect(word.reload.pl).to eq params[:word][:pl]
        end
      end

      context "not valid params" do
        let(:params) { { id: word.id, word: { en: "", pl: "" } } }

        it "renders edit template" do
          expect(response).to render_template(:edit)
        end

        it "has status 200" do
          expect(response.status).to eq 200
        end
      end
    end

    context "when user is not signed in" do
      let!(:word) { create(:word) }
      let(:params) { { id: word.id, word: { en: "dog", pl: "pies" } } }
      let(:call) { put :update, params }

      before { call }

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end

      it "has status 302" do
        expect(response.status).to eq 302
      end

      it "raises error" do
        expect { controller.create }.to raise_error(I18n.t("messages.login_to_add_new_word"))
      end
    end
  end

  describe "#destroy" do
    context "when user is signed in" do
      let!(:user) { create(:user) }
      
      before do
        controller.stub(:current_user) { user }
        request.env["HTTP_REFERER"] = root_url
      end

      context "when user is owner of this word" do
        let!(:word) { create(:word, user: user) }
        let(:params) { { id: word.id } }
        let(:call) { delete :destroy, params }

        it "has status 302" do
          call
          expect(response.status).to eq 302
        end
      
        it "deletes word" do
          expect { call }.to change { Word.count }.from(1).to(0)
        end
      end

      context "when user is not owner of this word" do
        let!(:user_2) { create(:user) }
        let!(:word) { create(:word, user: user_2) }
        let(:params) { { id: word.id } }
        let(:call) { delete :destroy, params }

        it "has status 302" do
          call
          expect(response.status).to eq 302
        end
      
        it "does not delete word" do
          expect { call }.not_to change { Word.count }
        end

        it "raises error" do
          expect { controller.destroy }.to raise_error(I18n.t("messages.you_can_not_delete_word"))
        end
      end
    end

    context "when user is not signed in" do
      let!(:word) { create(:word) }
      let(:params) { { id: word.id } }
      let(:call) { delete :destroy, params }

      before { call }

      it "redirects to root_path" do
        expect(response).to redirect_to(root_path)
      end

      it "has status 302" do
        expect(response.status).to eq 302
      end

      it "raises error" do
        expect { controller.destroy }.to raise_error(I18n.t("messages.you_can_not_delete_word"))
      end
    end
  end
end

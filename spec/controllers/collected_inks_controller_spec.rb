require 'rails_helper'

describe CollectedInksController do

  fixtures :collected_inks, :users
  render_views

  let(:user) { users(:moni) }

  describe '#index' do
    it 'requires authentication' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    context 'signed in' do
      let(:ink) { collected_inks(:monis_marine) }

      before(:each) do
        sign_in(user)
      end

      it 'renders the ink index page' do
        get :index
        expect(response).to be_successful
        expect(response.body).to include(ink.ink_name)
        expect(response.body).to include(ink.brand_name)
      end
    end
  end

  describe '#create' do
    it 'requires authentication' do
      expect do
        post :create, params: { collected_ink: { ink_name: 'Ink', brand_name: 'Brand'}}
        expect(response).to redirect_to(new_user_session_path)
      end.to_not change { CollectedInk.count }
    end

    context 'signed in' do
      before(:each) do
        sign_in(user)
      end

      it 'creates the data' do
        expect do
          post :create, params: { collected_ink: {
            ink_name: 'Ink',
            line_name: 'Line',
            brand_name: 'Brand',
            kind: 'bottle'
          }}
          expect(response).to redirect_to(collected_inks_path)
        end.to change { user.collected_inks.count }.by(1)
        collected_ink = user.collected_inks.last
        expect(collected_ink.brand_name).to eq('Brand')
        expect(collected_ink.line_name).to eq('Line')
        expect(collected_ink.ink_name).to eq('Ink')
        expect(collected_ink.kind).to eq('bottle')
      end
    end
  end

  describe '#update' do

    let(:collected_ink) { collected_inks(:monis_marine) }

    it 'requires authentication' do
      expect do
        put :update, params: { id: collected_ink.id, collected_ink: { ink_name: 'Not Marine' } }
        expect(response).to redirect_to(new_user_session_path)
      end.to_not change { collected_ink.reload }
    end

    context 'signed in' do
      let(:user) { users(:moni) }

      before(:each) do
        sign_in(user)
      end

      it 'updates the ink' do
        put :update, params: { id: collected_ink.id, collected_ink: { ink_name: 'Not Marine' } }
        expect(response).to redirect_to(collected_inks_path)
        collected_ink.reload
        expect(collected_ink.ink_name).to eq('Not Marine')
      end

    end
  end

  describe '#destroy' do

    let(:collected_ink) { collected_inks(:monis_marine) }
    it 'requires authentication' do
      expect do
        delete :destroy, params: { id: collected_ink.id }
        expect(response).to redirect_to(new_user_session_path)
      end.to_not change { CollectedInk.count }
    end

    describe 'signed in' do
      let(:user) { users(:moni) }

      before(:each) do
        sign_in(user)
      end

      it 'deletes the collected ink' do
        expect do
          delete :destroy, params: { id: collected_ink.id }
          expect(response).to redirect_to(collected_inks_path)
        end.to change { user.collected_inks.count }.by(-1)
      end

      it 'does not delete other users inks' do
        expect do
          delete :destroy, params: { id: collected_inks(:toms_marine) }
          expect(response).to redirect_to(collected_inks_path)
        end.to_not change { CollectedInk.count }
      end
    end
  end
end
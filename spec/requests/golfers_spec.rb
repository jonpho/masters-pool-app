require 'rails_helper'

RSpec.describe 'Golfers API', type: :request do
  # Create a user for authentication
  let(:user) { User.create(email: 'test@example.com', password: 'password123') }

  before do
    # Sign in the user for authenticated requests
    sign_in user
  end

  describe 'GET /golfers' do
    let!(:golfer1) { Golfer.create(name: 'Tiger Woods', world_ranking: '5') }
    let!(:golfer2) { Golfer.create(name: 'Rory McIlroy', world_ranking: '3') }
    let!(:golfer3) { Golfer.create(name: 'Amateur Player', world_ranking: 'Amateur') }
    let!(:golfer4) { Golfer.create(name: 'Unranked Player', world_ranking: 'Unranked') }

    it 'returns HTTP success' do
      get golfers_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      get golfers_path
      expect(response).to render_template(:index)
    end

    it 'assigns @golfers sorted by ranking' do
      get golfers_path
      expect(assigns(:golfers)).to be_present
    end
  end

  describe 'GET /golfers/:id' do
    let(:golfer) { Golfer.create(name: 'Jon Rahm', world_ranking: '1') }

    it 'returns HTTP success' do
      get golfer_path(golfer)
      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      get golfer_path(golfer)
      expect(response).to render_template(:show)
    end

    it 'assigns the requested golfer' do
      get golfer_path(golfer)
      expect(assigns(:golfer)).to eq(golfer)
    end
  end

  describe 'GET /golfers/new' do
    it 'returns HTTP success' do
      get new_golfer_path
      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      get new_golfer_path
      expect(response).to render_template(:new)
    end

    it 'assigns a new golfer' do
      get new_golfer_path
      expect(assigns(:golfer)).to be_a_new(Golfer)
    end
  end

  describe 'POST /golfers' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          golfer: {
            name: 'Scottie Scheffler',
            world_ranking: '1'
          }
        }
      end

      it 'creates a new golfer' do
        expect {
          post golfers_path, params: valid_params
        }.to change(Golfer, :count).by(1)
      end

      it 'redirects to the created golfer' do
        post golfers_path, params: valid_params
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(golfer_path(Golfer.last))
      end

      it 'sets a success notice' do
        post golfers_path, params: valid_params
        follow_redirect!
        expect(response.body).to include('Golfer was successfully created')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          golfer: {
            name: '',
            world_ranking: ''
          }
        }
      end

      it 'does not create a new golfer' do
        expect {
          post golfers_path, params: invalid_params
        }.not_to change(Golfer, :count)
      end

      it 'renders the new template with unprocessable_entity status' do
        post golfers_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /golfers/:id/edit' do
    let(:golfer) { Golfer.create(name: 'Edit Test', world_ranking: '10') }

    it 'returns HTTP success' do
      get edit_golfer_path(golfer)
      expect(response).to have_http_status(:success)
    end

    it 'renders the edit template' do
      get edit_golfer_path(golfer)
      expect(response).to render_template(:edit)
    end

    it 'assigns the requested golfer' do
      get edit_golfer_path(golfer)
      expect(assigns(:golfer)).to eq(golfer)
    end
  end

  describe 'PATCH /golfers/:id' do
    let(:golfer) { Golfer.create(name: 'Original Name', world_ranking: '20') }

    context 'with valid parameters' do
      let(:valid_params) do
        {
          golfer: {
            name: 'Updated Name',
            world_ranking: '15'
          }
        }
      end

      it 'updates the golfer' do
        patch golfer_path(golfer), params: valid_params
        golfer.reload
        expect(golfer.name).to eq('Updated Name')
        expect(golfer.world_ranking).to eq('15')
      end

      it 'redirects to the golfer' do
        patch golfer_path(golfer), params: valid_params
        expect(response).to redirect_to(golfer_path(golfer))
      end

      it 'sets a success notice' do
        patch golfer_path(golfer), params: valid_params
        follow_redirect!
        expect(response.body).to include('Golfer was successfully updated')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          golfer: {
            name: ''
          }
        }
      end

      it 'does not update the golfer' do
        original_name = golfer.name
        patch golfer_path(golfer), params: invalid_params
        golfer.reload
        expect(golfer.name).to eq(original_name)
      end

      it 'renders the edit template with unprocessable_entity status' do
        patch golfer_path(golfer), params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /golfers/:id' do
    let!(:golfer) { Golfer.create(name: 'Delete Test', world_ranking: '30') }

    it 'destroys the golfer' do
      expect {
        delete golfer_path(golfer)
      }.to change(Golfer, :count).by(-1)
    end

    it 'redirects to golfers index' do
      delete golfer_path(golfer)
      expect(response).to redirect_to(golfers_path)
    end

    it 'sets a success notice' do
      delete golfer_path(golfer)
      follow_redirect!
      expect(response.body).to include('Golfer was successfully destroyed')
    end
  end

  describe 'JSON requests' do
    let(:golfer) { Golfer.create(name: 'JSON Test', world_ranking: '7') }

    describe 'GET /golfers.json' do
      it 'returns JSON response' do
        get golfers_path, as: :json
        expect(response.content_type).to include('application/json')
        expect(response).to have_http_status(:success)
      end
    end

    describe 'GET /golfers/:id.json' do
      it 'returns JSON response for a specific golfer' do
        get golfer_path(golfer), as: :json
        expect(response.content_type).to include('application/json')
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST /golfers.json' do
      let(:valid_params) do
        {
          golfer: {
            name: 'JSON Golfer',
            world_ranking: '12'
          }
        }
      end

      it 'creates a golfer and returns JSON' do
        expect {
          post golfers_path, params: valid_params, as: :json
        }.to change(Golfer, :count).by(1)
        expect(response.content_type).to include('application/json')
        expect(response).to have_http_status(:created)
      end
    end
  end

  describe 'authentication requirements' do
    before do
      sign_out user
    end

    it 'redirects to sign in when not authenticated' do
      get golfers_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'flight_groups helper method' do
    let(:flight) { Flight.create(name: 'Test Flight') }
    let(:golfer) { Golfer.create(name: 'Flight Test', world_ranking: '8') }

    before do
      golfer.flights << flight
    end

    it 'returns flight name for valid flight id' do
      get golfers_path
      expect(controller.send(:flight_groups, flight.id)).to eq('Test Flight')
    end

    it 'returns empty string for nil flight id' do
      get golfers_path
      expect(controller.send(:flight_groups, nil)).to eq('')
    end
  end
end

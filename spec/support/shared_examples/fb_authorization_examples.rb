RSpec.shared_examples 'fb standard index authorization' do
  describe 'GET index' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        get "/api/v1/accounts/#{account.id}/#{path_name}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'returns success for agent' do
        get "/api/v1/accounts/#{account.id}/#{path_name}",
            headers: agent.create_new_auth_token,
            as: :json

        expect(response).to have_http_status(:success)
      end

      it 'return unauthorized for administrator of unrelated account' do
        get "/api/v1/accounts/#{account.id}/#{path_name}",
            headers: unrelated_admin.create_new_auth_token,
            as: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns success for administrator of related account' do
        get "/api/v1/accounts/#{account.id}/#{path_name}",
            headers: administrator.create_new_auth_token,
            as: :json

        expect(response).to have_http_status(:success)
      end
    end
  end
end

RSpec.shared_examples 'fb standard show authorization' do
  describe 'GET show' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        get "/api/v1/accounts/#{account.id}/#{path_name}/#{ids.first}"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when it is an authenticated user' do
      it 'return success for agent' do
        get "/api/v1/accounts/#{account.id}/#{path_name}/#{ids.first}",
            headers: agent.create_new_auth_token,
            as: :json

        expect(response).to have_http_status(:success)
      end

      it 'return unauthorized for administrator of unrelated account' do
        get "/api/v1/accounts/#{account.id}/#{path_name}/#{ids.first}",
            headers: unrelated_admin.create_new_auth_token,
            as: :json

        expect(response).to have_http_status(:unauthorized)
      end

      it 'return success for administrator of related account' do
        get "/api/v1/accounts/#{account.id}/#{path_name}/#{ids.first}",
            headers: administrator.create_new_auth_token,
            as: :json

        expect(response).to have_http_status(:success)
      end
    end
  end
end

RSpec.shared_examples 'fb standard create authorization' do
  describe 'POST' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        expect(klass.count).to eq object_counter
        post "/api/v1/accounts/#{account.id}/#{path_name}",
             params: post_params

        expect(response).to have_http_status(:unauthorized)
        expect(klass.count).to eq object_counter
      end
    end

    context 'when it is an authenticated user' do
      it 'returns unauthorized for administrator of unrelated account' do
        expect(klass.count).to eq object_counter
        post "/api/v1/accounts/#{account.id}/#{path_name}",
             headers: unrelated_admin.create_new_auth_token,
             as: :json,
             params: post_params

        expect(response).to have_http_status(:unauthorized)
        expect(klass.count).to eq object_counter
      end

      it 'creates the object for agent' do
        expect(klass.count).to eq object_counter
        post "/api/v1/accounts/#{account.id}/#{path_name}",
             headers: agent.create_new_auth_token,
             as: :json,
             params: post_params

        expect(response).to have_http_status(:success)
        expect(klass.count).to eq object_counter + 1
      end

      it 'creates the object for administrator of related account' do
        expect(klass.count).to eq object_counter
        post "/api/v1/accounts/#{account.id}/#{path_name}",
             headers: administrator.create_new_auth_token,
             as: :json,
             params: post_params

        expect(response).to have_http_status(:success)
        expect(klass.count).to eq object_counter + 1
      end
    end
  end
end

RSpec.shared_examples 'fb standard update authorization' do
  describe 'PATCH' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        expect(klass.find(id_target)[attr_target]).to eq current_state
        patch "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
              params: patch_params

        expect(response).to have_http_status(:unauthorized)
        expect(klass.find(id_target)[attr_target]).to eq current_state
      end
    end

    context 'when it is an authenticated user' do
      it 'returns unauthorized for agent who did not create object' do
        expect(klass.find(id_target)[attr_target]).to eq current_state
        patch "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
              headers: agent_two.create_new_auth_token,
              as: :json,
              params: patch_params

        expect(response).to have_http_status(:unauthorized)
        expect(klass.find(id_target)[attr_target]).to eq current_state
      end

      it 'returns unauthorized for administrator of unrelated account' do
        expect(klass.find(id_target)[attr_target]).to eq current_state
        patch "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
              headers: unrelated_admin.create_new_auth_token,
              as: :json,
              params: patch_params

        expect(response).to have_http_status(:unauthorized)
        expect(klass.find(id_target)[attr_target]).to eq current_state
      end

      it 'updates the object for agent who did create object' do
        expect(klass.find(id_target)[attr_target]).to eq current_state
        patch "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
              headers: agent.create_new_auth_token,
              as: :json,
              params: patch_params

        expect(response).to have_http_status(:success)
        expect(klass.find(id_target)[attr_target]).to eq new_state
      end

      it 'updates the object for administrator of related account' do
        expect(klass.find(id_target)[attr_target]).to eq current_state
        patch "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
              headers: administrator.create_new_auth_token,
              as: :json,
              params: patch_params

        expect(response).to have_http_status(:success)
        expect(klass.find(id_target)[attr_target]).to eq new_state
      end
    end
  end
end

RSpec.shared_examples 'fb standard destroy authorization' do
  describe 'DELETE' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}"

        expect(response).to have_http_status(:unauthorized)
        expect(klass.count).to eq object_counter
      end
    end

    context 'when it is an authenticated user' do
      it 'returns unauthorized for agent who did not create object' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
               headers: agent_two.create_new_auth_token,
               as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(klass.count).to eq object_counter
      end

      it 'returns unauthorized for administrator of unrelated account' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
               headers: unrelated_admin.create_new_auth_token,
               as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(klass.count).to eq object_counter
      end

      it 'destroys the object for agent who did create object' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
               headers: agent.create_new_auth_token,
               as: :json

        expect(response).to have_http_status(:success)
        expect(klass.count).to eq(0)
      end

      it 'destroys the object for administrator of related account' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/#{id_target}",
               headers: administrator.create_new_auth_token,
               as: :json

        expect(response).to have_http_status(:success)
        expect(klass.count).to eq(0)
      end
    end
  end
end

RSpec.shared_examples 'fb bulk patch authorization' do
  describe 'BULK PATCH' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        expect(klass.find(ids.first)[attr_target]).to eq(current_state)
        expect(klass.find(ids.second)[attr_target]).to eq(current_state)
        patch "/api/v1/accounts/#{account.id}/#{path_name}/bulk_update",
              params: bulk_patch_params
        expect(response).to have_http_status(:unauthorized)
        expect(klass.find(ids.first)[attr_target]).to eq(current_state)
        expect(klass.find(ids.second)[attr_target]).to eq(current_state)
      end
    end

    context 'when it is an authenticated user' do
      it 'return unauthorized for agent' do
        expect(klass.find(ids.first)[attr_target]).to eq(current_state)
        expect(klass.find(ids.second)[attr_target]).to eq(current_state)
        patch "/api/v1/accounts/#{account.id}/#{path_name}/bulk_update",
              headers: agent.create_new_auth_token,
              as: :json,
              params: bulk_patch_params
        expect(response).to have_http_status(:unauthorized)
        expect(klass.find(ids.first)[attr_target]).to eq(current_state)
        expect(klass.find(ids.second)[attr_target]).to eq(current_state)
      end

      it 'return unauthorized for administrator of unrelated account' do
        expect(klass.find(ids.first)[attr_target]).to eq(current_state)
        expect(klass.find(ids.second)[attr_target]).to eq(current_state)
        patch "/api/v1/accounts/#{account.id}/#{path_name}/bulk_update",
              headers: unrelated_admin.create_new_auth_token,
              as: :json,
              params: bulk_patch_params
        expect(response).to have_http_status(:unauthorized)
        expect(klass.find(ids.first)[attr_target]).to eq(current_state)
        expect(klass.find(ids.second)[attr_target]).to eq(current_state)
      end

      it 'updates objects when its administrator of related account' do
        expect(klass.find(ids.first)[attr_target]).to eq(current_state)
        expect(klass.find(ids.second)[attr_target]).to eq(current_state)
        patch "/api/v1/accounts/#{account.id}/#{path_name}/bulk_update",
              headers: administrator.create_new_auth_token,
              as: :json,
              params: bulk_patch_params
        expect(response).to have_http_status(:success)
        expect(klass.find(ids.first)[attr_target]).to eq(new_state)
        expect(klass.find(ids.second)[attr_target]).to eq(new_state)
      end
    end
  end
end

RSpec.shared_examples 'fb bulk delete authorization' do
  describe 'bulk DELETE' do
    context 'when it is an unauthenticated user' do
      it 'returns unauthorized' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/bulk_destroy",
               params: { ids: ids }
        expect(response).to have_http_status(:unauthorized)
        expect(klass.count).to eq object_counter
      end
    end

    context 'when it is an authenticated user' do
      it 'return unauthorized for agent' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/bulk_destroy",
               headers: agent.create_new_auth_token,
               as: :json,
               params: { ids: ids }

        expect(response).to have_http_status(:unauthorized)
        expect(klass.count).to eq object_counter
      end

      it 'return unauthorized for administrator of unrelated account' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/bulk_destroy",
               headers: unrelated_admin.create_new_auth_token,
               as: :json,
               params: { ids: ids }

        expect(response).to have_http_status(:unauthorized)
        expect(klass.count).to eq object_counter
      end

      it 'destroys the objects when its administrator of related account' do
        delete "/api/v1/accounts/#{account.id}/#{path_name}/bulk_destroy",
               headers: administrator.create_new_auth_token,
               as: :json,
               params: { ids: ids }

        expect(response).to have_http_status(:success)
        expect(klass.count).to eq 0
      end
    end
  end
end

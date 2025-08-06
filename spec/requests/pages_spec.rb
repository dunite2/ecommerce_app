require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /faq" do
    it "returns http success" do
      get "/pages/faq"
      expect(response).to have_http_status(:success)
    end
  end

end

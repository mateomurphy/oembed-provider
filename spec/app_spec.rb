require 'spec_helper'

describe App do
  def app
    described_class
  end

  context "with an existing photo", vcr: { cassette_name:  "photo/in9-n0JwgZ0" } do
    context "as json" do
      before do
        get '/oembed.json?url=https%3A%2F%2Funsplash.com%2F%3Fphoto%3Din9-n0JwgZ0'
      end

      it "returns a 200 status" do
        expect(last_response).to be_ok
      end

      it "has an json content type" do
        expect(last_response.content_type).to include('application/json')
      end
    end

    context "as xml" do
      before do
        get '/oembed.xml?url=https%3A%2F%2Funsplash.com%2F%3Fphoto%3Din9-n0JwgZ0'
      end

      it "returns a 200 status" do
        expect(last_response).to be_ok
      end

      it "has an xml content type" do
        expect(last_response.content_type).to include('application/xml')
      end

      it "is xml" do
        expect(last_response.body).to include('<oembed>')
      end
    end
  end

  context "with a missing url" do
    it "returns 400" do
      get '/oembed.json'

      expect(last_response).to be_a_bad_request
    end
  end

  context "with a non-existant photo", vcr: { cassette_name:  "photo/in9-n0JwgZ" } do
    it "returns 404" do
      get '/oembed.json?url=https%3A%2F%2Funsplash.com%2F%3Fphoto%3Din9-n0JwgZ'

      expect(last_response).to be_not_found
    end
  end
end

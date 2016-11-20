require 'spec_helper'

describe Photo do
  describe '.parse_url_param' do
    it 'returns the photo id' do
      result = Photo.parse_url_param('https://unsplash.com/?photo=in9-n0JwgZ0')
      expect(result).to eq('photo' => 'in9-n0JwgZ0')
    end
  end

  describe '.find_photo' do
    context 'with an existing photo', vcr: { cassette_name:  "photo/in9-n0JwgZ0" } do
      subject :result do
        Photo.find_photo('in9-n0JwgZ0')
      end

      it 'returns the photo' do
        expect(result).to be_a(Unsplash::Photo)
      end
    end

    context 'with an nonexistant photo', vcr: { cassette_name:  "photo/in9-n0JwgZ" } do
      subject :result do
        Photo.find_photo('in9-n0JwgZ')
      end

      it 'returns nil' do
        expect(result).to be_falsey
      end
    end
  end

  describe '.fetch' do
    context 'with an existing photo', vcr: { cassette_name:  "photo/in9-n0JwgZ0" } do
      subject :photo do
        Photo.fetch(url: 'https://unsplash.com/?photo=in9-n0JwgZ0')
      end

      describe 'result' do
        it 'return a photo instance' do
          expect(photo).to be_a(Photo)
        end
      end
    end

    context 'with a custom width', vcr: { cassette_name:  "photo/in9-n0JwgZ0_w_1000" } do
      subject :photo do
        Photo.fetch(url: 'https://unsplash.com/?photo=in9-n0JwgZ0', maxwidth: 1000)
      end

      describe '#width' do
        it 'uses the explicit width' do
          expect(photo.width).to eq(1000)
        end
      end

      describe '#height' do
        it 'uses a calculated height' do
          expect(photo.height).to eq(666)
        end
      end
    end

    context 'with a custom height', vcr: { cassette_name:  "photo/in9-n0JwgZ0_h_1000" } do
      subject :photo do
        Photo.fetch(url: 'https://unsplash.com/?photo=in9-n0JwgZ0', maxheight: 1000)
      end

      describe '#width' do
        it 'uses a calculated width' do
          expect(photo.width).to eq(1500)
        end
      end

      describe '#height' do
        it 'uses the explicit height' do
          expect(photo.height).to eq(1000)
        end
      end
    end

    context 'with a custom size', vcr: { cassette_name:  "photo/in9-n0JwgZ0_w_1000_h_1000" } do
      subject :photo do
        Photo.fetch(url: 'https://unsplash.com/?photo=in9-n0JwgZ0', maxheight: 1000, maxwidth: 1000)
      end

      describe '#width' do
        it 'uses the explicit width' do
          expect(photo.width).to eq(1000)
        end
      end

      describe '#height' do
        it 'uses the explicit height' do
          expect(photo.height).to eq(1000)
        end
      end
    end

    context 'with an nonexistant photo', vcr: { cassette_name:  "photo/in9-n0JwgZ" } do
      subject :photo do
        Photo.fetch(url: 'https://unsplash.com/?photo=in9-n0JwgZ')
      end

      describe 'result' do
        specify { expect(photo).to be_falsey }
      end
    end
  end
end

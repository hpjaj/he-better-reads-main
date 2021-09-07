RSpec.describe '/api/books' do
  let(:response_hash) { JSON(response.body, symbolize_names: true) }

  describe 'GET to /' do
    it 'returns all books' do
      book = create(:book)

      get api_books_path

      expect(response_hash).to eq(
        [
          {
            uuid: book.uuid,
            description: book.description,
            publish_date: book.publish_date,
            rating: book.rating,
            title: book.title,
            slug: book.title.parameterize,
            average_rating: book.average_rating,
            reviews_count: book.reviews_count,
            author: {
              id: author.id,
              first_name: author.first_name,
              last_name: author.last_name,
              website: author.website,
              genres: author.genres,
              description: author.description
            }
          }
        ]
      )
    end
  end

  describe 'GET to /:uuid' do
    context 'when found' do
      it 'returns an book' do
        book = create(:book)

        get api_book_path(book.uuid), headers: auth_headers(user)

        expect(response_hash).to eq(
          {
            uuid: book.uuid,
            description: book.description,
            publish_date: book.publish_date,
            rating: book.rating,
            title: book.title,
            slug: book.title.parameterize,
            average_rating: book.average_rating,
            reviews_count: book.reviews_count,
            author: {
              id: author.id,
              first_name: author.first_name,
              last_name: author.last_name,
              website: author.website,
              genres: author.genres,
              description: author.description
            }
          }
        )
      end
    end

    context 'when not found' do
      it 'returns not_found' do
        get api_book_path(-1)

        expect(response).to be_not_found
      end
    end
  end

  describe 'POST to /' do
    context 'when successful' do
      let(:author) { create(:author) }
      let(:params) do
        {
          description: 'It was the best of times',
          title: 'War and Peace',
          author_id: author.id
        }
      end

      it 'creates a book' do
        expect { post api_books_path, params: params }.to change { Book.count }
      end

      it 'returns the created book' do
        post api_books_path, params: params

        expect(response_hash).to include(params)
      end
    end

    context 'when unsuccessful' do
      let(:params) do
        {
          description: 'It was the best of times',
          title: 'War and Peace',
          author_id: -1
        }
      end

      it 'returns an error' do
        post api_books_path, params: params

        expect(response_hash).to eq(
          {
            errors: ['Author must exist']
          }
        )
      end
    end
  end

  describe 'PUT to /:uuid' do
    let(:book) { create(:book) }

    context 'when successful' do
      let(:params) do
        {
          description: 'I do not like green eggs and ham'
        }
      end

      it 'updates an existing book' do
        put api_book_path(book.uuid), params: params, headers: auth_headers(user)

        expect(book.reload.description).to eq(params[:description])
      end

      it 'returns the updated book' do
        put api_book_path(book.uuid), params: params, headers: auth_headers(user)

        expect(response_hash).to include(params)
      end
    end

    context 'when unsuccessful' do
      let(:params) do
        {
          description: ''
        }
      end

      it 'returns an error' do
        put api_book_path(book.uuid), params: params, headers: auth_headers(user)

        expect(response_hash).to eq(
          {
            errors: ['Description can\'t be blank']
          }
        )
      end
    end
  end
end

require 'rails_helper'

describe MoviesController do
  describe '#show_similar' do
    before(:each) do
      @lucas_movies = []
      @lucas_movies << Movie.create(title: "Star Wars", rating: "PG", director: "George Lucas", release_date: "1977-05-25")
      Movie.create(title: "Blade Runner", rating: "PG", director: "Ridley Scott", release_date: "1982-06-25")
      Movie.create(title: "Alien", rating: "R", director: "", release_date: "1979-05-25")
      @lucas_movies << Movie.create(title: "THX-1138", rating: "R", director: "George Lucas", release_date: "1971-03-11")

      @id = Movie.find_by_title("Star Wars").id

      allow(Movie).to receive(:get_same_director).with("George Lucas").and_return(@lucas_movies)
    end    

    it 'expect to recieve the ID of the movie to search' do
      get :show_similar, { id: @id }
      expect controller.params[:id] == @id
    end

    context 'if movie has a director' do
      it 'should render the "Show similar movies template"' do
        get :show_similar, { id: @id }
        should render_template(:show_similar)
      end
      it 'should provide list of similar movies to the template' do
        get :show_similar, { id: @id }
        expect assigns(:movie) == @movie
        expect assigns(:movies) == @lucas_movies
      end
    end

    context 'if movie deos not have a director' do
      before(:each) do
        @id = Movie.find_by_title("Alien").id
      end
      
      it 'should redirect to current movie page' do
        get :show_similar, { id: @id }
        expect(response).to redirect_to movie_path @id
      end

      it 'should display a message "This movie does not have a director specified"' do
        get :show_similar, { id: @id }
        expect(flash[:alert]).to eq "This movie does not have a director specified"
      end
    end
  end
end

require 'rails_helper'

describe MoviesController do
  before(:each) do
    @lucas_movies = []
    @lucas_movies << Movie.create(title: "Star Wars", rating: "PG", director: "George Lucas", release_date: "1977-05-25")
    Movie.create(title: "Blade Runner", rating: "PG", director: "Ridley Scott", release_date: "1982-06-25")
    Movie.create(title: "Alien", rating: "R", director: "", release_date: "1979-05-25")
    @lucas_movies << Movie.create(title: "THX-1138", rating: "R", director: "George Lucas", release_date: "1971-03-11")

    @movie = Movie.find_by_title("Star Wars")
    @id = @movie.id

    allow(Movie).to receive(:get_same_director).with("George Lucas").and_return(@lucas_movies)
  end
  
  describe '#show_similar' do
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
        expect(assigns(:movie)).to eq @movie
        expect(assigns(:movies)).to eq @lucas_movies
      end
    end

    context 'if movie deos not have a director' do
      before(:each) do
        @id = Movie.find_by_title("Alien").id
      end
      
      it 'should redirect to current movie page' do
        get :show_similar, { id: @id }
        expect(response).to redirect_to movies_path
      end

      it 'should display a message "This movie does not have a director specified"' do
        get :show_similar, { id: @id }
        expect(flash[:alert]).to eq "'Alien' has no director info"
      end
    end
  end

  describe '#show' do
    subject { get :show, { id: @id } }

    it 'renders the show template' do
      expect(subject).to render_template :show
    end
    it 'assigns the variables for the template' do
      subject
      expect(assigns(:movie)).to eq @movie
    end
  end

  describe '#update' do
    subject { put :update, id: @id, movie: { title: "Slut Whores", director: "George Sukas" } }

    it 'redirects to show movie page' do
      expect(subject).to redirect_to movie_path @id
    end
    it 'sets the flash notice to "Slut Whores was successfully updated."' do
      subject
      expect(flash[:notice]).to eq "Slut Whores was successfully updated."
    end

    it 'updates movie parameters' do
      subject
      movie = Movie.find @id
      expect(movie.title).to eq "Slut Whores"
      expect(movie.director).to eq "George Sukas"
    end
  end

  describe '#create' do
    let(:attr) do 
      { title: "Lost in Translation", rating: "PG", director: "Sophia Coppola", release_date: "2003-05-25" }
    end
    subject { post :create, movie: attr }

    it 'sets the flash notice with message "Movie_title was successfully created."' do
      subject
      expect(flash[:notice]).to eq "#{attr[:title]} was successfully created."
    end
    it 'redirects to show movie page' do 
      expect(subject).to redirect_to movies_path
    end
    it 'creates a new movie in the database' do
      subject
      movie = Movie.find_by_title attr[:title]
      expect(movie.title).to eq attr[:title]
      expect(movie.rating).to eq attr[:rating]
      expect(movie.director).to eq attr[:director]
      expect(movie.release_date).to eq attr[:release_date]
    end
  end

  describe '#destroy' do
    subject { delete :destroy, id: @id }

    it 'redirects to movies page' do 
      expect(subject).to redirect_to movies_path
    end
    it 'sets the flash notice to Movie movie_title deleted.' do
      subject
      expect(flash[:notice]).to eq "Movie '#{@movie.title}' deleted."
    end
    it 'removes the movie Star Wars from the database' do
      subject
      expect(Movie.find_by_title @movie.title).to be_nil
    end
  end

  describe '#index' do
    subject { get :index }

    it 'renders the index template' do
      expect(subject).to render_template :index
    end
    it 'sets the movies variable for template' do
      subject
      expect(assigns(:movies)).to include @movie
    end
    it 'sets the selected_ratings variable for template' do
      subject
      expect(assigns(:selected_ratings)).not_to be_empty
    end
    it 'sets the all_ratings variable for template' do
      subject
      expect(assigns(:all_ratings)).to include("G", "PG", "PG-13", "NC-17", "R")
    end
    it 'orders movies by title if sort=title is set' do
      get :index, sort: 'title'
      expect(assigns(:title_header)).to eq 'hilite'
    end
    it 'orders movies by date if sort=date is set' do
      get :index, sort: 'release_date'
      expect(assigns(:date_header)).to eq 'hilite'
    end
  end

  describe '#new' do
    subject { get :new }

    it 'renders a new template' do
      expect(subject).to render_template :new
    end
  end

  describe '#edit' do
    subject { get :edit, id: @id }

    it 'renders the edit form' do
      expect(subject).to render_template :edit
    end
    it 'sets the movie variable' do
      subject
      expect(assigns(:movie)).to eq @movie
    end
  end
end

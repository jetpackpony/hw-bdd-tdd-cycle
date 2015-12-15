require 'rails_helper'

describe Movie do
  describe '.get_same_director' do
    before(:each) do
      @lucas_movies = []
      @lucas_movies << Movie.create(title: "Star Wars", rating: "PG", director: "George Lucas", release_date: "1977-05-25")
      @blade_runner = Movie.create(title: "Blade Runner", rating: "PG", director: "Ridley Scott", release_date: "1982-06-25")
      @alien = Movie.create(title: "Alien", rating: "R", director: "", release_date: "1979-05-25")
      @lucas_movies << Movie.create(title: "THX-1138", rating: "R", director: "George Lucas", release_date: "1971-03-11")

      @director = Movie.find_by_title("Star Wars").director
    end

    context 'if movie has a director' do
      it 'should find movies by the same director' do
        expect(Movie.get_same_director @director).to eq @lucas_movies
      end
      it 'should not find moveis by different directors' do
        expect(Movie.get_same_director @director).not_to include @blade_runner
        expect(Movie.get_same_director @director).not_to include @alien
      end
    end
  end

  describe '.all_ratings' do
    it 'should return a non-empty array' do
      expect(Movie.all_ratings).not_to be_empty
    end
    it 'should return an array of ratings' do
      expect(Movie.all_ratings).to include("G", "PG", "PG-13", "NC-17", "R")
    end
  end
end

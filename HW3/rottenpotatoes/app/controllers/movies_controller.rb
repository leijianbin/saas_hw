class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort]
    head_class = params[:id]
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @selected_ratings = params[:ratings] || {'G'=>'1','PG'=>'1','PG-13'=>'1','R'=>'1','NC-17'=>'1'}

    case sort
    when "title"
      ordering = {:order => :title}
      @title_header = "hilite"
    when "release_date"
      ordering = {:order => :release_date}
      @date_header = "hilite"
    end
    #@movies = Movie.all 
    @movies = Movie.find_all_by_rating(@selected_ratings.keys,ordering)
  end

  def sort
    @sort_method = params[:sort_method]
    @movies = Movie.order(@sort_method)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

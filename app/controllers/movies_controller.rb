class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    if params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    
    if params[:to_sort].nil?
      session[:to_sort] = params[:to_sort]
    end
    
    if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:to_sort].nil? && !session[:to_sort].nil?)
      
      redirect_to movies_path("ratings" => session[:ratings], "to_sort" => session[:to_sort])
    elsif(!params[:ratings].nil? || !params[:to_sort].nil?)  
      if(params[:ratings].nil?)
        @ratings_to_show = []
        return @movies=Movie.all.order(session[:to_sort])
      else
        @ratings_to_show = params[:ratings].keys
        return @movies = Movie.with_ratings(@ratings_to_show).order(session[:to_sort])
      end
    elsif !session[:ratings].nil? || !session[:to_sort].nil?
      
      redirect_to movies_path("ratings" => session[:ratings], "to_sort" => session[:to_sort])
    else
      @ratings_to_show = @all_ratings
      return @movies = Movie.all
    end
      
#       if params[:to_sort].nil?
#         return @movies = Movie.all
#       end
#       return @movies = Movie.all.order(params[:to_sort])
#     else
#       if params[:to_sort].nil?
#         @ratings_to_show = params[:ratings].keys
#         return @movies = Movie.with_ratings(@ratings_to_show)
#       end
#       @ratings_to_show = params[:ratings].keys
#       return @movies = Movie.with_ratings(@ratings_to_show).order(params[:to_sort])
#     end 
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

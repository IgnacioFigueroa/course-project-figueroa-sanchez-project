class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  $current_post = 0
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.where(user_id: current_user)
  end

  # GET /posts/1
  # GET /posts/1.jsCOSon
  def show
    @post = Post.get_post(params[:id])
    $current_post = @post['id']
    @comments = Comment.get_post_comments(params[:id])
    if current_user
      @new_comment = Comment.new(user_id: current_user.id, post_id: params[:id])
    end
    location =  PostLocation.find_by_post_id(@post["id"])

    if location
      @latitude = location.latitude
      @longitude = location.longitude
      @has_location = true
    else
      @has_location = false
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    parameters = post_params
    @post = Post.new(title: parameters[:title], description: parameters[:description], user_id: current_user.id, images: parameters[:images], files: parameters[:files])
    latitude = post_params[:post_locations][:lat].to_f
    longitude = post_params[:post_locations][:lng].to_f
    location_id = post_params[:post_locations][:location_id]
    location = Location.find_by_location(location_id)
    respond_to do |format|
      if @post.save
        if post_params[:post_locations][:lat] != "" and post_params[:post_locations][:lng] != ""
          @post_location = PostLocation.create!(latitude: latitude, longitude: longitude, post_id: @post.id, location_id: location.id)
        end
        format.html {redirect_back(fallback_location: profile_path(@current_profile.id)); flash[:success] = 'Post created'}
      else
        format.html {redirect_back(fallback_location: profile_path(@current_profile.id)); flash[:danger] = 'Error creating post'}
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html {redirect_to @post, notice: 'Post was successfully updated.'}
        format.json {render :show, status: :ok, location: @post}
      else
        format.html {render :edit}
        format.json {render json: @post.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html {redirect_to posts_url, notice: 'Post was successfully destroyed.'}
      format.json {head 200}
    end
  end

  def post_solved
    redirect_back(fallback_location: root_path)
  end

  def vote_up
    validation = Validation.create(post: Post.find_by_id($current_post), user: current_user, vote: 1)
    redirect_back(fallback_location: root_path)
  end

  def vote_down
    validation = Validation.create(post: Post.find_by_id($current_post), user: current_user, vote: -1)
    redirect_back(fallback_location: root_path)
  end

  def follow_post
    follow_post = FollowPost.create(post: Post.find_by_id($current_post), user: current_user)
    redirect_back(fallback_location: root_path)
  end

  def shared_post
    shared_post = SharedPost.create(post: Post.find_by_id($current_post), user: current_user)
    redirect_back(fallback_location: root_path)
  end

  def new_comment
    comment = Comment.create(post: Post.find_by_id($current_post), user: current_user, comment: $new_comment)
    redirect_back(fallback_location: root_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    post = Post.where(id: params[:id])
    if post.length > 0
      if Post.find(params[:id]).is_in_dumpster?
        render :template => '/error_pages/404', :layout => false, :status => :not_found
      else
        @post = Post.find(params[:id])
      end
    else
      render :template => '/error_pages/404', :layout => false, :status => :not_found
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :description, images: [], files: [], post_locations: [:lat, :lng, :location_id])
  end
end
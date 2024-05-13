class Api::V1::PostsController < ApplicationController
  include ResponseConcern

  before_action :set_post, only: %i[ show update destroy ]
  skip_before_action :authenticate_user, only: %i[ index show ]

  def index
    @posts = Post.all

    render 'posts/index', layout: 'layouts/success'
  end

  def show
    render 'posts/show', layout: 'layouts/success'
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      render 'posts/show', layout: 'layouts/success'
    else
      @error = @post.errors
      render 'layouts/error', status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render 'posts/show', layout: 'layouts/success'
    else
      @error = @post.errors
      render 'layouts/error', status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.permit(:title, :text, :author_id)
    end
end

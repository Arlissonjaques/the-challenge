class Api::V1::CommentsController < ApplicationController
  include ResponseConcern

  before_action :set_comment, only: %i[ show update destroy ]
  skip_before_action :authenticate_user, only: %i[ index show ]

  def index
    @comments = Comment.all

    render 'comments/index', layout: 'layouts/success'
  end

  def show
    render 'comments/show', layout: 'layouts/success'
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render 'comments/show', layout: 'layouts/success'
    else
      @error = @comment.errors
      render 'layouts/error', status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render 'comments/show', layout: 'layouts/success'
    else
      @error = @comment.errors
      render 'layouts/error', status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.permit(:name, :comment, :post_id, :user_id)
    end
end

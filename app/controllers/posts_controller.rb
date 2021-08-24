class PostsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
	
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
	@post = Post.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end
	
	
  class Subset
	  def initialize(array)
		 @array = array
		 @result = Hash.new
	  end
	  def dfs(index, path)
		  @result[path] = []
		  for i in index..@array.length-1
			  dfs(i+1,path+[@array[i]])
		  end
	  end
	  def result
		  return @result
	  end
  end
	
	  

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
	post = @post
    respond_to do |format|
      if @post.save
		# 알람받을 대상 선정 알고리즘
		  
		  # 1) keyword 중복없이 조회
		  keywords = Keyword.select("DISTINCT (word)")
		  alert_keywords = Hash.new
		  tmp_keywords = []
		  whole_users = []
		  
		  # 2) 반복하여 keywords 원소 게시글 키워드매칭
		  keywords.each do |keyword|
			  if post.title.include? keyword.word
				  tmp_keyword_array = Keyword.select("DISTINCT (username)").where(word: keyword.word).all
				  alert_keywords[keyword.word] = []
				  tmp_keyword_array.each do |x| 
					  alert_keywords[keyword.word].push(x.username) 
				  end
				  whole_users = whole_users | alert_keywords[keyword.word]
				  tmp_keywords.push(keyword.word)
			  end
		  end

		  # 해시 : 키워드1 => [ 유저1, 유저2, 유저3,,] , 키워드2 => [ 유저2, 유저5, ,,,]
		  alert_keywords = Hash[alert_keywords.sort_by {|k, v| post.title.index(k)}]
		  tmp_keywords = tmp_keywords.sort_by{|k| post.title.index(k)}
		  whole_users = whole_users - [post.username]
		  
		  # 3) 매칭된 키워드들로 부분집합 만들기 dfs 이용 -> 2^n 개
		  subset = Subset.new(tmp_keywords)
		  subset.dfs(0,[])
		  subset_keyword = Hash[subset.result().sort_by {|k, v| -k.length}]
		  subset_keyword.delete([]) 
		  
		  # 4) 키워드 여러개 유저 
		  # 해시 : [키워드1] => [ 유저1, 유저3,,] , [키워드2] => [ 유저5, ,,,] , [키워드1,키워드2] => [ 유저2 ,,,]
		  subset_keyword.each do |key,value|
			  users = whole_users
			  key.each do |k|
				  users = users & alert_keywords[k]
			  end
			  subset_keyword[key] = users
			  alert_keywords.each do |x,y|
				  alert_keywords[x] = alert_keywords[x] - users
			  end
		  end
		  
		  # 5) 알람 전송
		   subset_keyword.each do |key,value|
			  value.each do |x|
				  # 비동기 sidekiq 사용
				    string_key = key*","
				 	data = '{ "username": "'+x+'", "word":"'+string_key+'", "title": "'+'['+string_key+' 키워드알람]'+'","description": "'+ ( ""<< post.username << "님의 글제목:"<< post.title ) +'" }'
				 	AlertJob.perform_later(data)
			  end
		  end

        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:username, :title, :description)
    end
end

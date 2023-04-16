class RecipesController < ApplicationController
    # before_action :authorize

    #GET /recipes
    def index
        recipes = Recipe.all        
        if  session[:user_id]
            render json: recipes, status: :created
        else
            render json: { errors: ["Not authorized"] }, status: :unauthorized
        end
    end

    #POST /recipes
    def create
        user = User.find_by(id: session[:user_id])
        # recipe = user.recipes.create(recipe_params)
        # render json: recipe
        if user
            recipe = user.recipes.create(recipe_params)
            render json: recipe, status: :created
        elsif 

            render json: { errors: ["unauthorized"]}, status: :unauthorized
        else
            if recipe.valid?
            render json: { errors: [recipe.errors.full_messages]}, status: :unprocessable_entity
        end
    end

private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def authorize
        user = User.find_by(id: session[:user_id])
        return render json: { errors: ["Not authorized"] }, status: :unauthorized
    end

end

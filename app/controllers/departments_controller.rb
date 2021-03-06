class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:new, :create, :show, :index, :edit, :update, :destroy]
  # GET /departments
  # GET /departments.json
  def index
     if current_user.super_admin?
      puts"=============superadmin============="
      @departments=Department.all
     else
      @departments = Department.data_from_same_group(current_user.group_id)
     end 
  end
  
  def all_deps
    @departments = Department.where("group_id = ? ",params[:group_id])
    puts "=====departments====="
    respond_to do |format|
        format.js
    end
  end
  
  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: 'Department was successfully created.' }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: 'Department was successfully updated.' }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url, notice: 'Department was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.require(:department).permit(:name, :status, :memo, :group_id)
    end

    def check_user
        unless current_user.super_admin? or current_user.content_admin? or current_user.local_admin?
          redirect_to root_path, notice: "Unauthorised access"
        end
    end
end

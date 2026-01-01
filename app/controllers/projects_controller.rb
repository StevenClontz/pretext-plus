class ProjectsController < ApplicationController
  allow_unauthenticated_access only: :share
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :limit_projects, only: %i[ new create ]

  # GET /projects or /projects.json
  def index
    @projects = Project.where user: @current_user
    @invitations = Invitation.where owner_user: @current_user, recipient_user: nil
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new user: @current_user, title: "New Project"
    @project.content = <<-eos
<?xml version="1.0" encoding="UTF-8"?>
<section>
<title>My Section</title>
<p>
  This is a paragraph.  It can contain <term>terms</term> and <em>emphasis</em>.
</p>
<fact>
<p>
This is a fact.
</p>
</fact>
<corollary>
<title>My Corollary</title>
<p>
  This is a paragraph in a section.  It can contain <term>terms</term> and <em>emphasis</em>.
</p>
</corollary>
<theorem>
<title>My Theorem</title>
<p>
  This is a paragraph in a section.  It can contain <term>terms</term> and <em>emphasis</em>.
</p>
</theorem>
<p>Lemma text here</p>
<p>Another paragraph</p>
<p>
  Welcome to this very basic demo of how tiptap can be used to edit PreTeXt.  First, a definition.
</p>

<conjecture>
<title>Title of Conjecture</title>

<p>
A <term>conjecture</term> is somethign you hope is true.
</p>
<p> Another paragraph </p>

</conjecture>

<definition>
<title>Title of Definition</title>

<p>
A <term>definition block</term> is a section of text that contains a definition.
</p>
<p> Another paragraph </p>

</definition>

<assumption>
<title>Title of Assumption</title>

<p>
An <term>assumption</term> is something you assume.
</p>

</assumption>

<ul>
  <li>
    That's a bullet list with one …
  </li>
  <li>
    … or two list items.
  </li>
</ul>

<p>
  Pretty neat, huh?  Oh yeah, and it can do some math: <m>\\int_1^2 x^2 dx = \\frac{7}{3}</m>.  I don't know if you can do display math though.  Perhaps <md>\\int_1^2 x^2 dx = \\frac{7}{3}</md> will work?
</p>
<theorem>
  <title>My Theorem</title>

  <p>This is a theorem</p>
  <p>Another paragraph</p>
</theorem>

<p> And that's the end of the demo.  Thanks for coming!</p>
</section>
    eos
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.update_attribute :user, @current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    @project.update_attribute :user, @current_user
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy!

    respond_to do |format|
      format.html { redirect_to projects_path, notice: "Project was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def share
    @project = Project.find(params.expect(:project_id))
    render html: @project.html_source.html_safe
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.expect(project: [ :title, :content ])
    end

    # redirect if user has too many projects
    def limit_projects
      if @current_user && @current_user.projects.count >= 10
        redirect_to projects_path, alert: "You have reached the maximum number of projects allowed."
      end
    end
end

class DocumentsController < ApplicationController
  before_action :require_login
  before_action :set_document, only: [:show, :download_pdf]
  
  def index
    @documents = current_user.documents.order(created_at: :desc)
  end

  def new
    @document = Document.new
  end

  def create
    @document = current_user.documents.build(document_params)
    if @document.save
      redirect_to @document, notice: "Document created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end
  
  def download_pdf
    require 'open3'
    require 'tempfile'
    
    # Create a temporary directory for LaTeX compilation
    Dir.mktmpdir do |tmpdir|
      tex_file = File.join(tmpdir, "document.tex")
      
      # Write the LaTeX content to the file
      File.write(tex_file, @document.content)
      
      # Run pdflatex
      stdout, stderr, status = Open3.capture3(
        "pdflatex",
        "-interaction=nonstopmode",
        "-output-directory=#{tmpdir}",
        tex_file
      )
      
      pdf_file = File.join(tmpdir, "document.pdf")
      
      if File.exist?(pdf_file)
        send_file pdf_file,
                  filename: "#{@document.title.parameterize}.pdf",
                  type: "application/pdf",
                  disposition: "attachment"
      else
        redirect_to @document, alert: "Failed to generate PDF. Please check your LaTeX syntax."
      end
    end
  end
  
  private
  
  def set_document
    @document = current_user.documents.find(params[:id])
  end
  
  def document_params
    params.require(:document).permit(:title, :content)
  end
end

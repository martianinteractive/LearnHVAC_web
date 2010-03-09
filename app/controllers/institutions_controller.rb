class InstitutionsController < ApplicationController
  before_filter :require_superadmin
  
  def index
    @institutions = Institution.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @institutions }
    end
  end

  def show
    @institution = Institution.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @institution }
    end
  end

  def new
    @institution = Institution.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @institution }
    end
  end

  def edit
    @institution = Institution.find(params[:id])
  end

  def create
    @institution = Institution.new(params[:institution])

    respond_to do |format|
      if @institution.save
        format.html { redirect_to(@institution, :notice => 'Institution was successfully created.') }
        format.xml  { render :xml => @institution, :status => :created, :location => @institution }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end


  def update
    @institution = Institution.find(params[:id])

    respond_to do |format|
      if @institution.update_attributes(params[:institution])
        format.html { redirect_to(@institution, :notice => 'Institution was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @institution.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @institution = Institution.find(params[:id])
    @institution.destroy

    respond_to do |format|
      format.html { redirect_to(institutions_url) }
      format.xml  { head :ok }
    end
  end
end

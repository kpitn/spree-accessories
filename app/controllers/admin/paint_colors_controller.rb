class Admin::PaintColorsController < Admin::BaseController
  resource_controller
  belongs_to :product
  before_filter :load_object, :only => [:selected,:remove,:create]


  def create
    if !params[:color] or params[:color].blank?
      flash[:error] = "Veuillez saisir un numéro"
      redirect_to selected_admin_product_paint_colors_url(@product)
      return
    end
    PaintColorType.all.each do |type|

      if params[:color].include?(",")
        params[:color].split(",").each do |color|
          insert_color(type,color)
        end
      else
        insert_color(type,params[:color])
      end
    end
    redirect_to selected_admin_product_paint_colors_url(@product)
  end
#
#  def destroy
#    render :text=>"ok"
#  end
  destroy.wants.js { render :text=>"ok"}

  private
    def insert_color(type,color)
      if color.to_i<100
        ref=type.reference.gsub("XXX","1#{color.rjust(2,"0")}")
      else
        ref=type.reference.gsub("XXX",color)
      end
      v=Variant.find_by_sku("revell-#{ref}")
      if v and v.product
        pc=PaintColor.find(:first,:conditions=>["product_id=? and color_id=?",@product.id,v.product.id])
        PaintColor.create(:product=>@product,:color_product=>v.product,:paint_color_type_id=>type.id) unless pc
        return true
      else
        return false
      end
    end

end
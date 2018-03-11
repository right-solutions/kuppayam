module Demo
  class MaterializeHomeController < Demo::MaterializeBaseController

    def index
    end

    private

    def set_navs
      set_nav("demo/home")
    end

  end
end


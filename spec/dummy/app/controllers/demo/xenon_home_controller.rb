module Demo
  class XenonHomeController < Demo::XenonBaseController

    def index
    end

    private

    def set_navs
      set_nav("demo/home")
    end

  end
end


module Demo
  class HomeController < Demo::BaseController

    def index
    end

    private

    def set_navs
      set_nav("demo/home")
    end

  end
end


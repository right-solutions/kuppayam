module Demo
  class AdminController < Demo::BaseController

    def index
    end

    private

    def set_navs
      set_nav("demo/admin")
    end

  end
end


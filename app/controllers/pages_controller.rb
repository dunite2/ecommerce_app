class PagesController < ApplicationController
  def faq
    @page = Page.find_by_slug('faq')
  end

  def about
    @page = Page.find_by_slug('about')
  end

  def contact
    @page = Page.find_by_slug('contact')
  end
end

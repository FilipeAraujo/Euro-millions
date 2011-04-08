module ApplicationHelper
  def html_safe(text)
         return text if text.nil?
         return text.html_safe if defined?(ActiveSupport::SafeBuffer)
         return text.html_safe! if text.respond_to?(:html_safe!)
         text
  end


end

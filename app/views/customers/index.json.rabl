collection @customers
attributes :id, :name, :registered_at, :postal_code, :phone
node(:movies_checked_out_count) {|customer| movies_out_count(customer) }


# def movies_out_count
#   return self.rentals.where({checkin_date: nil}).count
# end
#
# :movies_out_count

# object @article
# attributes :id, :name, :published_at
#
# if current_user.admin?
#   node(:edit_url) { |article| edit_article_url(article) }
# end
#
# child :author do
#   attributes :id, :name
#   node(:url) { |author| author_url(author) }
# end
#
# child :comments do
#   attributes :id, :name, :content
# end

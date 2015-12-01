module UsersHelperPatch
	def self.included(base)
		base.send(:include, InstanceMethods)

		# Execute this code at the class level (not instance level)
		base.class_eval do
			unloadable # Send unloadable so it will not be unloaded in development

		end #base.class_eval
	end

	module InstanceMethods
		def users_status_options_for_select_with_parent_id(selected)
			user_count_by_status = User.where("parent_id = ?", User.current.id).group('status').count.to_hash
			options_for_select([
				[l(:label_all), ''],
				["#{l(:status_active)} (#{user_count_by_status[1].to_i})", '1'],
				["#{l(:status_registered)} (#{user_count_by_status[2].to_i})", '2'],
				["#{l(:status_locked)} (#{user_count_by_status[3].to_i})", '3']
			], selected.to_s)
		end

		def users_select(form, id_field, users, opts = {})
			form.select(id_field, users.map { |u| [u.name, u.id] }.sort, opts)
		end

# 		def render_descendants_tree(user)
# 	s = '<form><table class="list users">'
# 	user_list(user.descendants.preload(:children).sort_by(&:lft)) do |child, level|
# 		css = "issue issue-#{child.id} hascontextmenu"
# 		css << " idnt idnt-#{level}" if level > 0
# 		s << content_tag('tr',
# 					 content_tag('td', avatar(user, :size => "14"), child.id, false, :id => nil), :class => 'username') +
# 					 content_tag('td', mail_to(user.mail), :class => 'email', :style => 'width: 50%') +
# 					 content_tag('td', h(child.status)) +
# 					 content_tag('td', (format_time(user.last_login_on) unless user.last_login_on.nil? ), :class => 'last_login_on') +
# 					 content_tag('td', user.groups.map(&:to_s).sort.join(', '), :class => 'username',:width => '80px')),
# 					 :class => css)
# 	end
# 	s << '</table></form>'
# 	s.html_safe
# end

def render_descendants_tree(user)
	# s = '<form><table class="list issues">'
	# user_list(user.descendants.sort_by(&:lft)) do |child, level|
	# 	css = "issue issue-#{child.id} hascontextmenu"
	# 	css << " idnt idnt-#{level}" if level > 0
	# 	s << content_tag('tr',
	# 				 content_tag('td', child.username) +
	# 				 :class => css)
	# end
	# s << '</table></form>'
	# s.html_safe
	puts user.id
	if User.where("parent_id=?", 275)
		puts User.where("parent_id=?", user.id)
		puts user.class
		puts user.inspect
		puts "YEEE"
	else
		puts "NO KIDS"
	end
end

def user_list(users, &block)
	parents = []
	user.each do |issue|
		while (parents.any? && !user.parent?(parents.last))
			parents.pop
		end
		yield user, parents.size
		parents << user if user.children
	end
end

		def valid_user_parents
	(User.all.select(&:active?) + User.where("id=?",@user.parent_id) - [@user] - @user.descendants).uniq
		end
	end
end

UsersHelper.send :include, UsersHelperPatch

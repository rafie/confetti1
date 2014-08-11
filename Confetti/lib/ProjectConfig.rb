
require_relative 'Confetti'
require_relative 'CSpec'
require_relative 'LSpec'
require_relative 'Lot'

module Confetti

#----------------------------------------------------------------------------------------------

# (project project-name
# 	(baseline
#		cspec)
# 
#   :branch branch # optional (default: project-name_int)
# 	:stem stem # optional (default: project-name)
# 	:icheck N
# 	:itag N
#   :upstream stream # optional (useful in activity and feature streams)
# 	
# 	(lots
# 		lot-names ...)
# 	
# 	(products
# 		(product product-name :lot product-lot))
# )

# :stem specifies prefix of checks
# :icheck specifies last check number applied (starts with 0)
# :itag specifies last tag applied (starts with 0)
# :upstream specifies the upstream (for rebase/deliver operations)

class ProjectConfig
	include Bento::Class

	def from_files(main, lspec)
		@main_file = main.is_a?(File) ? main : File.new(main.to_s)
		@lspec_file = lspec.is_a?(File) ? lspec : File.new(lspec.to_s)
		@name = project_name # extract name from main config file
		assert_good
	end

	def from_path(path)
		from_files(File.new(path + "/project.ne"), File.new(path + "/lots.ne"))
	end

	def create(name, branch: nil, baseline_cspec: nil, lspec: nil, upstream: nil)
		raise "invalid project name" if name.to_s.strip.empty?
		@name = name

		# check_type baseline_cspec, Confetti.CSpec
		# check_type! also does not allow nils
		raise "invalid cspec" if !baseline_cspec || ! baseline_cspec.is_a?(Confetti::CSpec)
		baseline_cspec = baseline_cspec if baseline_cspec

		raise "invalid lspec" if !lspec || ! lspec.is_a?(Confetti::LSpec)
		@lspec = lspec if lspec

		# @upstream = Confetti.Stream(upstream) if upstream

		@nexp = Nexp::Nexp.from_string(MainConfigTemplate.new(self, baseline_cspec), :single)

		assert_good
	end

	def create_from_config(name, branch: nil, config: nil)
		assert_good
	end

	def assert_good
		return if \
			   @name \
			&& (@nexp || @main_file) \
			&& (@lspec || @lspec_file)
		raise "ProjectConfig no good" 
	end

	#-------------------------------------------------------------------------------------------

	class MainConfigTemplate
		@@config_t = <<-END
(project <%= @name %>
	(baseline 
		<%= baseline_cspec.to_s %>)
	:itag 0
	:icheck 0
	(lots 
		<%for lot in @lots %> <%= lot %> <% end %>))
END

		def initialize(project_config, baseline_cspec)
			@self = project_config
			@name = @self.project_name
			@lots = @self.lspec.lot.keys
			@baseline_cspec = baseline_cspec
		end

		def text
			Bento.mold(@@config_t, bindings)
		end
	end

	#-------------------------------------------------------------------------------------------

	def nexp
		return @main_nexp if @main_nexp
		@main_nexp = Nexp::Nexp.from_file(@main_file, :single)
	end

	def lspec
		return @lspec if @lspec
		@lspec = Confetti::LSpec.from_file(@lspec_file)
	end

	#-------------------------------------------------------------------------------------------

	def project_name
		~nexp.cadr
	end

	def project_name=(name)
		nexp.cadr = name
	end

	def stem
		nexp[:stem]
	end

	def icheck
		nexp[:icheck]
	end

	def inc_icheck
		nexp[:icheck] = nexp[:icheck].to_i + 1
	end

	def itag
		nexp[:itag]
	end

	def inc_itag
		nexp[:itag] = nexp[:itag].to_i + 1
	end

	def upstream
		nexp[:upstream]
	end

	def lots
	end

	def baseline
		Confetti.CSpec(nexp[:baseline].to_s)
	end

	def baseline=
	end

	def products
		raise "unimplemented"
	end

	#-------------------------------------------------------------------------------------------

	def cspec
	end

	#-------------------------------------------------------------------------------------------

	def files
		[@main_config_file, @lspec_file]
	end

	def write(path)
		File.write(path, config)
		File.write(path, @lspec.to_s)
	end

	def add_to_view(view)
		path = main_config_file
		view.add_files(path)

		path = lots_config_file
		view.add_files(path)
	end

	#-------------------------------------------------------------------------------------------

#	def self.is(*args)
#		x = self.new; x.send(:is, *args); x
#	end

	def self.from_files(*args)
		x = self.send(:new); x.send(:from_files, *args); x
	end

	def self.from_path(*args)
		x = self.send(:new); x.send(:from_path, *args); x
	end

	def self.create(*args)
		x = self.send(:new); x.send(:create, *args); x
	end

	private :from_files, :from_path, :create
	private_class_method :new
end # Project

#def self.ProjectConfig(*args)
#	x = Project.send(:new); x.send(:is, *args); x
#end

#----------------------------------------------------------------------------------------------

end # module Confetti

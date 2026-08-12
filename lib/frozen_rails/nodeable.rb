module Nodeable
  extend ActiveSupport::Concern

  REQUIRED_EXECUTABLES = %w[ node yarn ].freeze

  private

  def require_js_toolchain!
    missing = REQUIRED_EXECUTABLES.reject { |executable| available?(executable) }
    return if missing.empty?

    raise Thor::Error, <<~MSG
      frozen_rails could not run #{missing.to_sentence}.

      node and yarn are provided by nvm, which is only active in a shell that has
      sourced it. Activate it, then run this generator again:

      #{activation_hint(missing).indent(4)}
    MSG
  end

  # `system` returns nil when the command does not exist and false when it exits non-zero
  def available?(executable)
    system(executable, "--version", out: File::NULL, err: File::NULL)
  end

  def activation_hint(missing)
    commands = [ nvm_use_command ]
    commands << "npm install -g yarn" if missing.include?("yarn")
    commands << "bin/rails generate #{self.class.namespace}"
    commands.join("\n")
  end

  def nvm_use_command
    # nvm picks the version out of .nvmrc by itself
    return "nvm use" if File.exist?(".nvmrc")

    version = File.read(".node-version").strip if File.exist?(".node-version")
    "nvm use #{version || '--lts'}"
  end
end

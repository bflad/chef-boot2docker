require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

# Helpers module
module Helpers
  # Helpers::Boot2docker module
  module Boot2docker
    # Exception to signify that the boot2docker daemon is not yet ready to handle
    # boot2docker commands.
    class Boot2dockerNotReady < StandardError
      def initialize(timeout)
        super <<-EOH
The boot2docker daemon did not become ready within #{timeout} seconds.
This most likely means that boot2docker failed to start.
boot2docker can fail to start if:

  - Virtualbox cannot start or run.

If this problem persists, check your service log files.
EOH
      end
    end

    # Exception to signify that the boot2docker command timed out.
    class CommandTimeout < RuntimeError; end

    def timeout
      node['boot2docker']['cmd_timeout']
    end

    # This is based upon wait_until_ready! from the opscode jenkins cookbook.
    #
    # Since the boot2docker service returns immediately and the actual boot2docker
    # process is started as a daemon, we block the Chef Client run until the
    # daemon is actually ready.
    #
    # This method will effectively "block" the current thread until the boot2docker
    # daemon is ready
    #
    # @raise [boot2dockerNotReady]
    #   if the boot2docker master does not respond within (+timeout+) seconds
    #
    def wait_until_ready!
      Timeout.timeout(timeout) do
        loop do
          result = shell_out('boot2docker info')
          break if Array(result.valid_exit_codes).include?(result.exitstatus)
          Chef::Log.debug("boot2docker daemon is not running - #{result.stdout}\n#{result.stderr}")
          sleep(0.5)
        end
      end
    rescue Timeout::Error
      raise boot2dockerNotReady.new(timeout), 'boot2docker timeout exceeded'
    end

    # the Error message to display if a command times out. Subclasses
    # may want to override this to provide more details on the timeout.
    def command_timeout_error_message
      <<-EOM

Command timed out:
#{cmd}

EOM
    end

    # Runs a boot2docker command. Does not raise exception on non-zero exit code.
    def boot2docker_cmd(cmd, timeout = new_resource.cmd_timeout)
      execute_cmd('boot2docker ' + cmd, timeout)
    end

    # Executes the given command with the specified timeout. Does not raise an
    # exception on a non-zero exit code.
    def execute_cmd(cmd, timeout = new_resource.cmd_timeout)
      Chef::Log.debug('Executing: ' + cmd)
      begin
        shell_out(cmd, :timeout => timeout)
      rescue Mixlib::ShellOut::CommandTimeout
        raise CommandTimeout, command_timeout_error_message
      end
    end

    # Executes the given boot2docker command with the specified timeout. Raises an
    # exception if the command returns a non-zero exit code.
    def boot2docker_cmd!(cmd, timeout = new_resource.cmd_timeout)
      execute_cmd!('boot2docker ' + cmd, timeout)
    end

    # Executes the given command with the specified timeout. Raises an
    # exception if the command returns a non-zero exit code.
    def execute_cmd!(cmd, timeout = new_resource.cmd_timeout)
      cmd = execute_cmd(cmd, timeout)
      cmd.error!
      cmd
    end
  end
end

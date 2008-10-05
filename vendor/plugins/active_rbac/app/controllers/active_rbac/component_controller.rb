require_dependency 'application'

# All controllers in ActiveRBAC extend this controller.
#
# It is only responsible for loading the model classes and the RbacHelper
# at the moment.
class ActiveRbac::ComponentController < ApplicationController
  helper :rbac
end
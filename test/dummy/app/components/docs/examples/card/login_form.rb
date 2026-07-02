# frozen_string_literal: true

module Docs
  module Examples
    module Card
      class LoginForm < Phlex::HTML
        def view_template
          render PhlexKit::Card.new(class: "w-md") do
            render PhlexKit::CardHeader.new do
              render PhlexKit::CardTitle.new { "Login to your account" }
              render PhlexKit::CardDescription.new { "Enter your email below to login to your account" }
            end
            render PhlexKit::CardContent.new do
              div(class: "stack") do
                render PhlexKit::FormField.new do
                  render PhlexKit::FormFieldLabel.new(for: "card-email") { "Email" }
                  render PhlexKit::Input.new(type: :email, id: "card-email", placeholder: "m@example.com", required: true)
                  render PhlexKit::FormFieldError.new
                end
                render PhlexKit::FormField.new do
                  render PhlexKit::FormFieldLabel.new(for: "card-password") { "Password" }
                  render PhlexKit::Input.new(type: :password, id: "card-password", required: true)
                  render PhlexKit::FormFieldError.new
                end
              end
            end
            render PhlexKit::CardFooter.new do
              render PhlexKit::Button.new { "Login" }
              render PhlexKit::Button.new(variant: :outline) { "Sign up" }
            end
          end
        end
      end
    end
  end
end

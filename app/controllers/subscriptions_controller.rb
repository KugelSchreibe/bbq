class SubscriptionsController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_subscription, only: %i[destroy]

  def create
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    if using_email?(subscription_params[:user_email])
      redirect_to @event, alert: t('controllers.subscriptions.defined_errors.existing_email')
    else
      if @new_subscription.save
        redirect_to @event, notice: I18n.t('controllers.subscriptions.created')
      else
        redirect_to 'events/show', alert: I18n.t('controllers.subscriptions.error')
      end
    end
  end

  def destroy
    message = {notice: I18n.t('controllers.subscriptions.destroyed')}
    if current_user_can_edit?(@subscription)
      @subscription.destroy
    else
      message = {alert: I18n.t('controllers.subscriptions.error')}
    end

    redirect_to @event, message
  end

  private

  def set_subscription
    @subscription = @event.subscriptions.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def subscription_params
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end

  def using_email?(email)
    User.find_by(email: email).present?
  end
end
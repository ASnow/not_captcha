Rails.application.routes.draw do
  get 'not_captcha/:hash' => "not_captcha/captcha#show" , as: :captcha_page
end
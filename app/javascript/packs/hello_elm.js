// Run this example by adding <%= javascript_pack_tag "hello_elm" %> to the
// head of your layout file, like app/views/layouts/application.html.erb.
// It will render "Hello Elm!" within the page.

import Elm from '../Main';

document.addEventListener('turbolinks:load', () => {
  console.log('a');
  const target = document.getElementById('elm-main')

  if (target) {
    Elm.Main.embed(target)
  }
})

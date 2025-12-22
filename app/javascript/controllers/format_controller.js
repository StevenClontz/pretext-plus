import { Controller } from "@hotwired/stimulus"
import { formatPretext } from "@pretextbook/format";

export default class extends Controller {
  static targets = [ "textarea" ]

  format() {
    const element = this.textareaTarget
    console.log(element)
    element.value = formatPretext(element.value)
  }
}

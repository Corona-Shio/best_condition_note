import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hamburger", "account"];

  toggleMenu(event) {
    event.preventDefault();
    this.hamburgerTarget.classList.toggle("collapse");
  }

  toggleDropdown(event) {
    event.preventDefault();
    this.accountTarget.classList.toggle("active");
  }
}

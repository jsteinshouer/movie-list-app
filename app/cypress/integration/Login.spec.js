describe('The Login Page', () => {
    beforeEach(() => {
  
      // seed a user in the DB that we can control from our tests
      // assuming it generates a random password for us
      cy.request('POST', '/tests/util/seedTestData.cfm', { username: 'jim.james' })
        .its('body')
        .as('currentUser')
    })
  
    it('sets auth cookie when logging in via form submission', function () {
      // destructuring assignment of the this.currentUser object
      const { email, password } = this.currentUser
  
      cy.visit('/login')
  
      cy.get('input[name=email]').type(email)

      cy.intercept('POST', '/api/authorize').as('authenticate')
  
      // {enter} causes the form to submit
      cy.get('input[name=password]').type(`${password}{enter}`)

      cy.wait('@authenticate').its('response.statusCode').should('be.equal', 200)
      
      // our auth cookie should be present
      cy.getCookie( Cypress.env('AUTH_COOKIE_NAME') ).should('exist')

      // we should be redirected to /mymovies
      cy.url().should('include', '/mymovies')
    })

    it('shows error using invalid credentials', function () {
        // destructuring assignment of the this.currentUser object
        const { email, password } = this.currentUser
    
        cy.visit('/login')
    
        cy.get('input[name=email]').type(email)
  
        cy.intercept('POST', '/api/authorize').as('authenticate')
    
        // {enter} causes the form to submit
        cy.get('input[name=password]').type(`thewrongpassword{enter}`)
  
        cy.wait('@authenticate').its('response.statusCode').should('be.equal', 401)

        cy.url().should('include', '/login')

        cy.get('[data-cy="error-msg"]').should('have.text', "Invalid credentials.")
      })

  })
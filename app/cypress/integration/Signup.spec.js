describe('The Signup Page', () => {
    beforeEach(() => {
  
      // seed a user in the DB that we can control from our tests
      // assuming it generates a random password for us
      cy.request('POST', '/tests/util/seedTestData.cfm', { username: 'jim.halpert@dundermifflin.com' })
        .its('body')
        .as('testUser')
    })
  
    it('adds a new user account', function () {

      cy.visit('/signup')
  
      cy.get('input[name=email]').type( 'dwight.schrute@dundermifflin.com' )

      cy.intercept('POST', '/api/signup').as('signup')
  
      // {enter} causes the form to submit
      cy.get('input[name=password]').type(`'fuzzyspacemonitor`)
      cy.get('input[name=confirm_password]').type(`'fuzzyspacemonitor{enter}`)

      cy.wait('@signup').its('response.statusCode').should('be.equal', 201)

      // we should be redirected to /mymovies
      cy.url().should('include', '/signup/confirm')
    })

    it('shows error with account that is already taken', function () {
    
        cy.visit('/signup')
        cy.intercept('POST', '/api/signup').as('signup')
        
        cy.get('input[name=email]').type("jim.halpert@dundermifflin.com")
        cy.get('input[name=password]').type(`gYj*9F#^MNw5z59`)
        cy.get('input[name=confirm_password]').type(`gYj*9F#^MNw5z59{enter}`)
  
        cy.wait('@signup').its('response.statusCode').should('be.equal', 400)

        cy.url().should('include', '/signup')

        cy.get('[data-cy="error-msg"]').should('have.text', "An account already exists for jim.halpert@dundermifflin.com.")
      })

      it('shows error when trying to signup with a weak password', function () {
    
        cy.visit('/signup')
        cy.intercept('POST', '/api/signup').as('signup')
    
        cy.get('input[name=email]').type("pam.beesley@dundermifflin.com")
        cy.get('input[name=password]').type(`password1`)
        cy.get('input[name=confirm_password]').type(`password1{enter}`)
  
        cy.wait('@signup').its('response.statusCode').should('be.equal', 400)

        cy.url().should('include', '/signup')

        cy.get('[data-cy="error-msg"]').should('have.text', "The password is too weak. This is a top-10 common password. Add another word or two. Uncommon words are better.")
      })

      it('shows error when passwords do not match', function () {
    
        cy.visit('/signup')
    
        cy.get('input[name=email]').type("pam.beesley@dundermifflin.com")
        cy.get('input[name=password]').type(`gYj*9F#^MNw5z59`)
        cy.get('input[name=confirm_password]').type(`gYj*9F#^MNw5z59z{enter}`)

        cy.url().should('include', '/signup')

        cy.get('[data-cy="error-msg"]').should('have.text', "Password and Confirm Password do not match.")
      })

  })
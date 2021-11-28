describe('View Page', () => {

    beforeEach(() => {

        // seed a post in the DB that we control from our tests
        // cy.request('GET', '/tests/e2e/resetData.cfm')

        cy.intercept('GET', '/api/whoami', { fixture: "whoami.json" });
        cy.intercept('GET', '/api/movie/tt0079588', { fixture: "view-tt0079588.json" });
        cy.intercept('GET', '/api/mymovies*', { fixture: "view-mymovies.json" });

    })


    it('Should be able to view the movie details', () => {
        cy.visit('/view/tt0079588')

        cy.contains('h1.title', 'The Muppet Movie').should('be.visible')
        cy.get('img.poster').should('be.visible')
        cy.contains('dd', '1979').should('be.visible')
    })

    it('Should have a button to allow my to add it to my list', () => {
        cy.visit('/view/tt0079588')

        cy.contains('button', 'ADD TO MY LIST').should('be.visible')
    })

     it('Should be able to add a movie to my list ', () => {

        cy.request('POST', '/tests/util/seedTestData.cfm', { username: 'michael.scott@dundermifflin.com' }).then(
            (response) => {
                let { email, password } = response.body

                cy.request('POST', '/api/authorize', { "username": email, "password": password });
        
        
                cy.visit('/view/tt0079588')
        
                cy.intercept( {
                    method: "POST",
                    url: "/api/mymovies"
                } ).as("apiAddMovie")
                cy.contains('button', 'ADD TO MY LIST').should('be.visible')
                cy.get('[data-cy="toggle-my-list"]').click();
        
                cy.wait('@apiAddMovie').then((interception) => {
                    assert.isNotNull(interception.response.body, 'API returned data')
                    assert.isNotNull(interception.response.body.data.id, 'API returned an id for the movie')
                    cy.contains('button', 'REMOVE FROM MY LIST').should('be.visible')
                })
            }
          )

    })
})
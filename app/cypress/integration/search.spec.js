describe('Search Page', () => {

    beforeEach(() => {
  
        // assuming it generates a random password for us
        cy.intercept('GET', '/api/whoami', { fixture: "whoami.json" });
    })

    it('Should load the page', () => {
        cy.visit('/search')
        cy.get('[data-cy="movie-list"]').should('not.contain', 'li');
    })

    it('Should be able to search for a movie', () => {
        cy.visit('/search')
        cy.intercept('GET', '/api/search*', { fixture: "search-muppet.json" });
        cy.get('[data-cy="btn-search"]').type('muppet{enter}')
        cy.get('[data-cy="movie-list"] li').should('have.length', 10)
        cy.contains('li div.title', 'The Muppet Movie').should('be.visible')
    })

})
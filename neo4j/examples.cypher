MATCH (actor:Person)-[:ACTED_IN]->(movie:Movie {title: 'The Matrix'})
RETURN actor.name AS ActorName;

MATCH (actor:Person)-[:ACTED_IN]->(movie:Movie)<-[:DIRECTED]-(actor)
RETURN actor.name AS ActorName, movie.title AS MovieTitle;

MATCH (actor:Person)-[:ACTED_IN]->(movie1:Movie {title: 'The Matrix'}),
      (actor)-[:ACTED_IN]->(movie2:Movie {title: 'V for Vendetta'})
RETURN actor.name AS ActorName;

MATCH (actor:Person)-[:ACTED_IN]->(movie:Movie)
  WHERE actor.born > 1980
RETURN movie.title AS MovieTitle, collect(actor.name) AS YoungActors;

MATCH (keanu:Person {name: 'Keanu Reeves'})-[:ACTED_IN]->(movie:Movie)<-[:ACTED_IN]-(coActor:Person)
  WHERE coActor.name <> 'Keanu Reeves'
RETURN DISTINCT coActor.name AS CoActorName;

MATCH (movie:Movie)<-[:REVIEWED]-(reviewer)
RETURN movie.title AS MovieTitle, count(reviewer) AS ReviewCount
  ORDER BY ReviewCount DESC;

MATCH (actor:Person)-[rel:ACTED_IN]->(movie:Movie)
  WHERE size(rel.roles) > 1
RETURN actor.name AS ActorName, movie.title AS MovieTitle, rel.roles AS Roles;

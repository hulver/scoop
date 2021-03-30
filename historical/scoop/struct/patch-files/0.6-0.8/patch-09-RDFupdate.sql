INSERT INTO vars VALUES ('rdf_http_proxy','','If set, then the proxy to use when fetching RDF''s. Otherwise, disables proxy use. Should be in the form http://host:port/','text','RDF');

INSERT INTO vars VALUES ('rdf_max_headlines','15','Default max number of titles to display for each RDF channel.','num','RDF');

UPDATE box SET content = 'return unless $S->{UI}->{VARS}->{use_rdf_feeds};

REPLACE INTO box (boxid, title, content, description, template) VALUES ('submit_rdf', 'Submit Feed', 'return "Sorry, you don\'t have permission to submit a feed."
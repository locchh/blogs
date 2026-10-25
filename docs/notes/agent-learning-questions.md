# Open questions about agent learning

These reflections came out of “When Code Is Cheap.” They are saved separately so that article can stay focused on where developers should spend their attention as implementation gets cheaper.

## Curiosity beyond the assigned task

Keep the decisions, evidence, limitations, and unanswered questions with the result. This gives the next person somewhere to start. It also leaves room for the curiosity I still associate with human intelligence: something bothers us, connects to an old idea, and keeps us thinking after the assigned task ends. A model can produce useful follow-up questions, but that output alone does not settle whether it has curiosity of its own.

## What kind of input could an agent learn from?

There is another open question I want to keep open: **what kind of input could support an agent's ability to learn, reason, and discover?** Natural language has vocabulary and grammar that let us express relationships and ideas nobody has written before. It also carries assumptions, biases, contradictions, fiction, and lies. Could another kind of input preserve useful expressive power while making some of those problems easier to handle?

For an agent whose job is to solve problems and act, what input would help it learn about actions and their consequences? Mathematics, machine states, sensor readings, and interaction with an environment give me places to look. I have not decided what form such an input should take. Would it need something like vocabulary and grammar? How would it carry context or uncertainty? What new relationships could a model discover? Whether changing the input would help with errors or hallucination is also a question to investigate.

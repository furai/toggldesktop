// Copyright 2015 Toggl Desktop developers.

#ifndef SRC_AUTOTRACKER_H_
#define SRC_AUTOTRACKER_H_

#include <string>
#include <sstream>
#include <vector>

#include <Poco/Types.h>

#include "model/base_model.h"
#include "model/timeline_event.h"

namespace toggl {

class TOGGL_INTERNAL_EXPORT AutotrackerRule : public BaseModel {
 public:
    AutotrackerRule() : BaseModel() {}
    // Before undeleting, see how the copy constructor in BaseModel works
    AutotrackerRule(const AutotrackerRule &o) = delete;
    AutotrackerRule &operator=(const AutotrackerRule &o) = delete;
    virtual ~AutotrackerRule() {}

    Property<std::string> Term { "" };
    Property<Poco::UInt64> PID { 0 };
    Property<Poco::UInt64> TID { 0 };

    bool Matches(const TimelineEvent &event) const;

    void SetTerm(const std::string &value);
    void SetPID(Poco::UInt64 value);
    void SetTID(Poco::UInt64 value);

    // Override BaseModel
    std::string String() const override;
    std::string ModelName() const override;
    std::string ModelURL() const override;
};

};  // namespace toggl

#endif  // SRC_AUTOTRACKER_H_

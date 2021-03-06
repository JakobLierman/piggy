////////////////////////////////////////////////////////////////////////////
//
// Copyright 2017 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#ifndef REALM_OS_PRIMITIVE_LIST_NOTIFIER_HPP
#define REALM_OS_PRIMITIVE_LIST_NOTIFIER_HPP

#include "impl/collection_notifier.hpp"

#include <realm/group_shared.hpp>

namespace realm {
namespace _impl {
class PrimitiveListNotifier : public CollectionNotifier {
public:
    PrimitiveListNotifier(TableRef lv, std::shared_ptr<Realm> realm);

private:
    // The subtable, in handover form if this has not been attached to the main
    // SharedGroup yet
    TableRef m_table;
    std::unique_ptr<SharedGroup::Handover<Table>> m_table_handover;

    // The last-seen size of the Table so that we can report row deletions
    // when the Table itself is deleted
    size_t m_prev_size;

    // The actual change, calculated in run() and delivered in prepare_handover()
    CollectionChangeBuilder m_change;
    TransactionChangeInfo* m_info;

    void run() override;

    void do_prepare_handover(SharedGroup&) override;

    void do_attach_to(SharedGroup& sg) override;
    void do_detach_from(SharedGroup& sg) override;

    void release_data() noexcept override;
    bool do_add_required_change_info(TransactionChangeInfo& info) override;
};
}
}

#endif // REALM_OS_PRIMITIVE_LIST_NOTIFIER_HPP
